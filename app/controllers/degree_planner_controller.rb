class DegreePlannerController < ApplicationController
  before_action :require_authenticated_user

  def select_course
    @courses = Course.all
  end

  def submit_course_selection
    session[:course_id] = params[:course_id]
    redirect_to degree_planner_step1_path
  end

  def step1
    if session[:course_id].nil?
      redirect_to degree_planner_select_course_path and return
    end

    @course = Course.find(session[:course_id])
    @subjects = @course.subjects.order(:code)
  end

  def submit_step1
    session[:completed_subject_ids] = params[:completed_subject_ids] || []
    session[:want_to_complete_ids] = params[:want_to_complete_ids] || []
    session[:difficulty] = params[:difficulty] || "balanced"
    session[:start_year] = params[:start_year] || Time.current.year
    session[:start_semester] = params[:start_semester] || (Time.current.month <= 6 ? "1" : "2")
    session[:grades] = params[:grades] || {}
    redirect_to degree_planner_plan_path
  end

  def step2
    @completed_subject_ids = session[:completed_subject_ids] || []
  end

  def submit_step2
    session[:start_year] = params[:start_year]
    session[:start_semester] = params[:start_semester]
    redirect_to degree_planner_plan_path
  end

  def plan
    if session[:course_id].nil?
      redirect_to degree_planner_select_course_path and return
    end

    @course = Course.find(session[:course_id])
    @completed_subject_ids = session[:completed_subject_ids] || []
    @want_to_complete_ids = session[:want_to_complete_ids] || []
    @difficulty = session[:difficulty] || "balanced"
    @start_year = session[:start_year]
    @start_semester = session[:start_semester]
    @grades = session[:grades] || {}

    # Get all subjects
    all_subjects = @course.subjects.to_a
    completed_subjects = all_subjects.select { |s| @completed_subject_ids.include?(s.id.to_s) }

    # Only plan for subjects marked as "want to complete" that aren't already completed
    want_to_complete_subjects = all_subjects.select { |s|
      @want_to_complete_ids.include?(s.id.to_s) && !@completed_subject_ids.include?(s.id.to_s)
    }

    # Sort subjects to complete using topological sort with difficulty
    @semester_plan = generate_semester_plan(want_to_complete_subjects, completed_subjects, @start_year.to_i, @start_semester.to_i, @difficulty)

    # Calculate credit points
    @total_completed_cp = completed_subjects.sum(&:credit_points)
    @total_planned_cp = want_to_complete_subjects.sum(&:credit_points)
    @total_cp = @total_completed_cp + @total_planned_cp

    # Calculate GPA for completed subjects with grades
    @completed_subjects = completed_subjects
    weighted_sum = 0
    total_cp_with_grades = 0

    completed_subjects.each do |subject|
      grade = @grades[subject.id.to_s]
      if grade.present? && grade.to_f > 0
        weighted_sum += subject.credit_points * grade.to_f
        total_cp_with_grades += subject.credit_points
      end
    end

    @gpa = total_cp_with_grades > 0 ? (weighted_sum / total_cp_with_grades).round(2) : nil
  end

  private

  def generate_semester_plan(remaining_subjects, completed_subjects, start_year, start_semester, difficulty = "balanced")
    # Build prerequisite graph
    subject_map = remaining_subjects.index_by(&:code)
    completed_codes = completed_subjects.map(&:code).to_set

    # Calculate in-degree (number of prerequisites) for each subject
    in_degree = {}
    adjacency_list = {}

    remaining_subjects.each do |subject|
      in_degree[subject.code] = 0
      adjacency_list[subject.code] = []
    end

    # Build graph
    remaining_subjects.each do |subject|
      prereq_codes = subject.prerequisite_codes.select { |code| subject_map.key?(code) }
      prereq_codes.each do |prereq_code|
        adjacency_list[prereq_code] << subject.code
        in_degree[subject.code] += 1
      end
    end

    # Topological sort using Kahn's algorithm
    # Calculate initial CP from completed subjects
    completed_cp = completed_subjects.sum(&:credit_points)

    queue = []
    remaining_subjects.each do |subject|
      prereqs = subject.prerequisite_codes
      required_cp = subject.required_cp

      # Check if all prerequisites are met
      all_prereqs_met = prereqs.all? { |prereq| completed_codes.include?(prereq) || !subject_map.key?(prereq) }
      cp_requirement_met = completed_cp >= required_cp

      if all_prereqs_met && cp_requirement_met
        queue << subject.code
      end
    end

    semester_plan = []
    current_year = start_year
    current_semester = start_semester
    semester_capacity = 4 # 4 subjects per semester
    cumulative_cp = completed_cp # Track CP as we schedule

    while queue.any?
      # Select subjects for this semester based on difficulty
      available_subjects = queue.map { |code| subject_map[code] }
      semester_subjects = []

      case difficulty
      when "hard"
        # Prioritize core units first
        core_subjects = available_subjects.select { |s| s.unit_type == "Core" }
        other_subjects = available_subjects.reject { |s| s.unit_type == "Core" }

        # Fill with core units first, then others
        selected = (core_subjects + other_subjects).take(semester_capacity)
        selected.each do |subject|
          queue.delete(subject.code)
          semester_subjects << subject
          cumulative_cp += subject.credit_points

          # Update in-degree for dependent subjects
          adjacency_list[subject.code].each do |dependent_code|
            in_degree[dependent_code] -= 1
            if in_degree[dependent_code] == 0
              queue << dependent_code unless queue.include?(dependent_code)
            end
          end
        end

        # Check if any subjects now meet CP requirements after this semester
        remaining_subjects.each do |subject|
          next if queue.include?(subject.code)
          next if semester_subjects.include?(subject)

          prereqs = subject.prerequisite_codes
          required_cp = subject.required_cp

          all_prereqs_met = prereqs.all? { |prereq| completed_codes.include?(prereq) || !subject_map.key?(prereq) }
          cp_requirement_met = cumulative_cp >= required_cp

          if all_prereqs_met && cp_requirement_met && in_degree[subject.code] == 0
            queue << subject.code unless queue.include?(subject.code)
          end
        end

      when "easy"
        # Spread out core units, buffer with QUT You and easy electives
        qut_you = available_subjects.select { |s| s.unit_type == "QUT You" }
        core_subjects = available_subjects.select { |s| s.unit_type == "Core" }
        electives = available_subjects.reject { |s| ["Core", "QUT You"].include?(s.unit_type) }

        # Try to include max 1 core unit per semester, fill with QUT You and electives
        selected = []
        selected << core_subjects.first if core_subjects.any?
        selected += qut_you.take(semester_capacity - selected.count)
        selected += electives.take(semester_capacity - selected.count)
        selected = selected.take(semester_capacity)

        selected.each do |subject|
          queue.delete(subject.code)
          semester_subjects << subject
          cumulative_cp += subject.credit_points

          # Update in-degree for dependent subjects
          adjacency_list[subject.code].each do |dependent_code|
            in_degree[dependent_code] -= 1
            if in_degree[dependent_code] == 0
              queue << dependent_code unless queue.include?(dependent_code)
            end
          end
        end

        # Check if any subjects now meet CP requirements after this semester
        remaining_subjects.each do |subject|
          next if queue.include?(subject.code)
          next if semester_subjects.include?(subject)

          prereqs = subject.prerequisite_codes
          required_cp = subject.required_cp

          all_prereqs_met = prereqs.all? { |prereq| completed_codes.include?(prereq) || !subject_map.key?(prereq) }
          cp_requirement_met = cumulative_cp >= required_cp

          if all_prereqs_met && cp_requirement_met && in_degree[subject.code] == 0
            queue << subject.code unless queue.include?(subject.code)
          end
        end

      else # balanced
        # Mix of all types evenly
        core_subjects = available_subjects.select { |s| s.unit_type == "Core" }
        qut_you = available_subjects.select { |s| s.unit_type == "QUT You" }
        electives = available_subjects.reject { |s| ["Core", "QUT You"].include?(s.unit_type) }

        # Try to balance types: aim for ~2 core, ~1 QUT You, ~1 elective per semester
        selected = []
        selected += core_subjects.take(2)
        selected += qut_you.take([1, semester_capacity - selected.count].min) if qut_you.any?
        selected += electives.take(semester_capacity - selected.count) if electives.any?

        # If still space and more subjects available, fill up
        remaining_available = (core_subjects + qut_you + electives) - selected
        selected += remaining_available.take(semester_capacity - selected.count)

        selected.each do |subject|
          queue.delete(subject.code)
          semester_subjects << subject
          cumulative_cp += subject.credit_points

          # Update in-degree for dependent subjects
          adjacency_list[subject.code].each do |dependent_code|
            in_degree[dependent_code] -= 1
            if in_degree[dependent_code] == 0
              queue << dependent_code unless queue.include?(dependent_code)
            end
          end
        end

        # Check if any subjects now meet CP requirements after this semester
        remaining_subjects.each do |subject|
          next if queue.include?(subject.code)
          next if semester_subjects.include?(subject)

          prereqs = subject.prerequisite_codes
          required_cp = subject.required_cp

          all_prereqs_met = prereqs.all? { |prereq| completed_codes.include?(prereq) || !subject_map.key?(prereq) }
          cp_requirement_met = cumulative_cp >= required_cp

          if all_prereqs_met && cp_requirement_met && in_degree[subject.code] == 0
            queue << subject.code unless queue.include?(subject.code)
          end
        end
      end

      if semester_subjects.any?
        semester_plan << {
          year: current_year,
          semester: current_semester,
          subjects: semester_subjects
        }

        # Move to next semester
        if current_semester == 1
          current_semester = 2
        else
          current_semester = 1
          current_year += 1
        end
      else
        break # No more subjects can be scheduled
      end
    end

    semester_plan
  end
end
