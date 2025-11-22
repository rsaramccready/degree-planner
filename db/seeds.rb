# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

user_one = User.create(name: "Your name", email: "you@hackathon.com", password: "tandahackathon2026")

# Create Law course
law_course = Course.find_or_create_by!(name: "Bachelor of Laws (Honours)") do |c|
  c.description = "QUT Law degree with comprehensive subject list. Requires 384 credit points total."
end

# Clear existing subjects for this course
law_course.subjects.destroy_all

# Law subjects data with unit types
subjects_data = [
  # Core units (20 units = 240 CP) - REQUIRED
  { code: "LLB101", name: "Introduction to Law", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "LLB102", name: "Torts", prerequisites: "LLB101", credit_points: 12, unit_type: "Core" },
  { code: "LLB104", name: "Contemporary Law and Justice", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "LLB106", name: "Criminal Law", prerequisites: "LLB101, LWB145", credit_points: 12, unit_type: "Core" },
  { code: "LLB107", name: "Statutory Interpretation", prerequisites: "LLB101", credit_points: 12, unit_type: "Core" },
  { code: "LLB108", name: "Law, Governance and Sustainability", prerequisites: "LLB101", credit_points: 12, unit_type: "Core" },
  { code: "LLB202", name: "Contract Law", prerequisites: "LLB102, LWB148", credit_points: 12, unit_type: "Core" },
  { code: "LLB203", name: "Constitutional Law", prerequisites: "LLB105, LLB107", credit_points: 12, unit_type: "Core" },
  { code: "LLB204", name: "Commercial and Personal Property Law", prerequisites: "LLB202, LWB137", credit_points: 12, unit_type: "Core" },
  { code: "LLB205", name: "Equity and Trusts", prerequisites: "LLB202, LWB137", credit_points: 12, unit_type: "Core" },
  { code: "LLB301", name: "Real Property Law", prerequisites: "LLB204, LLB205, LWB241", credit_points: 12, unit_type: "Core" },
  { code: "LLB303", name: "Evidence", prerequisites: "LLB106, LWB239", credit_points: 12, unit_type: "Core" },
  { code: "LLB304", name: "Commercial Remedies", prerequisites: "LLB204, LLB205, LWB241", credit_points: 12, unit_type: "Core" },
  { code: "LLB306", name: "Civil Dispute Resolution", prerequisites: "LLB202", credit_points: 12, unit_type: "Core" },
  { code: "LLH201", name: "Legal Research", prerequisites: "LLB105, LLB107", credit_points: 12, unit_type: "Core" },
  { code: "LLH206", name: "Administrative Law", prerequisites: "LLB203, LLH201, LWB242", credit_points: 12, unit_type: "Core" },
  { code: "LLH302", name: "Ethics and the Legal Profession", prerequisites: "LLH201, LWB146", credit_points: 12, unit_type: "Core" },
  { code: "LLH305", name: "Corporate Law", prerequisites: "LLB204, LLH201, LWB244", credit_points: 12, unit_type: "Core" },
  { code: "LLH402", name: "Legal Research Project", prerequisites: "144 CP required", credit_points: 12, unit_type: "Core" },
  { code: "LLH403", name: "Legal Industry Capstone Project", prerequisites: "LLH402", credit_points: 12, unit_type: "Core" },

  # General Law Electives
  { code: "LLB140", name: "Human Rights Law", prerequisites: "LLB101", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB142", name: "Regulation of Business", prerequisites: "LLB101, LWB145", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB150", name: "Behavioural Law and Economics", prerequisites: "", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB241", name: "Discrimination and Equal Opportunity Law", prerequisites: "LLB107, LLB105, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB242", name: "Media Law", prerequisites: "", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB243", name: "Family Law", prerequisites: "LLB101, LLB105, LLB107, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB244", name: "Criminal Law Sentencing", prerequisites: "LLB106, LWB239", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB245", name: "Sports Law", prerequisites: "LLB102, LLB106", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB246", name: "Workplace Law", prerequisites: "LLB107, LLB202", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB247", name: "Animal Law", prerequisites: "LLB101, LLB104, LLH201", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB248", name: "Public Health and the Law", prerequisites: "LLB101", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB250", name: "Data Privacy and Cybersecurity", prerequisites: "", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB251", name: "Legal Design", prerequisites: "LLB104, LLB106, LLB202", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB252", name: "Legal Coding and Prompt Engineering", prerequisites: "LLB101", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB340", name: "Banking and Finance Law", prerequisites: "LLB301, LWB244", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB341", name: "Artificial Intelligence, Robots and the Law", prerequisites: "LLH201", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB342", name: "Immigration and Refugee Law", prerequisites: "LLH201", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB343", name: "Indigenous Cultural Heritage Law", prerequisites: "LLB104, LLB105, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB344", name: "Intellectual Property Law", prerequisites: "LLH201, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB345", name: "Regulating the Internet", prerequisites: "LLH201, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB346", name: "Succession Law", prerequisites: "LWB241, LLB205", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB347", name: "Taxation Law", prerequisites: "LLB101", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB350", name: "The Law and Ethics of War", prerequisites: "LLH201, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB440", name: "Environmental Law", prerequisites: "LLH206, LWB335", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB443", name: "Mining and Resources Law", prerequisites: "LLB202, LWB137", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB444", name: "Real Estate Transactions", prerequisites: "LLB304, LWB137, LLB205, LWB241", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB447", name: "International Arbitration", prerequisites: "LLB204, LWB243", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB460", name: "Competition Moots A", prerequisites: "LLH201, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB461", name: "Competition Moots B", prerequisites: "LLH201, LWB146", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB463", name: "Legal Placement", prerequisites: "LLB104, LLB105, LLB107", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB464", name: "International Legal Placement", prerequisites: "LLB104, LLB105, LLB107", credit_points: 12, unit_type: "General Law Elective" },
  { code: "LLB467", name: "Law, Innovation and Technology Industry Project", prerequisites: "LLB101", credit_points: 12, unit_type: "General Law Elective" },

  # Law, Technology & Innovation Minor
  { code: "LLB249", name: "Introduction to Technology Law", prerequisites: "", credit_points: 12, unit_type: "Law Tech & Innovation Minor" },
  { code: "LLB352", name: "Smart Contracts and Blockchain Governance", prerequisites: "", credit_points: 12, unit_type: "Law Tech & Innovation Minor" },
  { code: "LLB353", name: "Governing Artificial Intelligence", prerequisites: "", credit_points: 12, unit_type: "Law Tech & Innovation Minor" },

  # Advanced Law Electives (need to choose 2 = 24 CP)
  { code: "LLH470", name: "Commercial Contracts in Practice", prerequisites: "LLH305", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH471", name: "Health Law and Practice", prerequisites: "LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH472", name: "Public International Law", prerequisites: "LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH473", name: "Independent Research Project", prerequisites: "LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH474", name: "Insolvency Law", prerequisites: "LLH305", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH475", name: "Theories of Law", prerequisites: "LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH476", name: "Competition Law", prerequisites: "LLH305", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH477", name: "Innovation and Intellectual Property Law", prerequisites: "LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH478", name: "Advanced Criminal Law - Principles and Practice", prerequisites: "LLB106, LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH479", name: "Research Thesis Extension", prerequisites: "", credit_points: 24, unit_type: "Advanced Law Elective" },
  { code: "LLH480", name: "Consumer Law in a Digital Age", prerequisites: "LLH305", credit_points: 12, unit_type: "Advanced Law Elective" },
  { code: "LLH481", name: "Private International Law", prerequisites: "LLH302", credit_points: 12, unit_type: "Advanced Law Elective" },

  # QUT You units (need to choose 4 = 24 CP)
  { code: "QUT001", name: "QUT You: Artificial Intelligence in the Real World", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT002", name: "QUT You: Walking on Country", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT003", name: "QUT You: Real Action for Real Change", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT004", name: "QUT You: Living and Working Collaboratively, Ethically, and Inclusively", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT005", name: "QUT You: Seeing Me, Seeing You: Skills for a Diverse World", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT006", name: "QUT You: The Art of Pitching", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT007", name: "QUT You: Fighting 'Fake News'", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT008", name: "QUT You: Think Like a Computer and Change the World", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT009", name: "QUT You: Data Science for Society", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT010", name: "QUT You: People with Robots", prerequisites: "", credit_points: 6, unit_type: "QUT You" }
]

# Create subjects
subjects_data.each do |subject_data|
  law_course.subjects.create!(subject_data)
end

# Create IT course
it_course = Course.find_or_create_by!(name: "Bachelor of Information Technology (Computer Science)") do |c|
  c.description = "QUT IT degree with Computer Science major. Requires 288 credit points total: Core units (108 CP), Major (72 CP), QUT You (24 CP), Complementary studies (84 CP)."
end

# Clear existing subjects for this course
it_course.subjects.destroy_all

# IT subjects data
it_subjects_data = [
  # Core units
  { code: "IFB102", name: "Introduction to Computer Systems", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "IFB103", name: "IT Systems Design", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "IFB104", name: "Introduction to Programming", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "IFB105", name: "Database Management", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "IFB201", name: "Introduction to Enterprise Computing", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "IFB220", name: "Introduction to AI for IT Professionals", prerequisites: "IFB104 or EGB103", credit_points: 12, unit_type: "Core" },
  { code: "IFB240", name: "Cyber Security", prerequisites: "", credit_points: 12, unit_type: "Core" },
  { code: "IFB320", name: "Generative AI", prerequisites: "(IFB220 or DSB102) and CAB201 (CAB201 concurrent ok)", credit_points: 12, unit_type: "Core" },
  { code: "IFB398", name: "IT Capstone Project (Phase 1)", prerequisites: "[(IAB251 or CAB302 or IAB320 or IAB321 or IFB343 or CAB330 or IAB305) and completion of 10 IT units] or 192cp of DS01", credit_points: 12, unit_type: "Core" },
  { code: "IFB399", name: "IT Capstone Project (Phase 2)", prerequisites: "IFB398 or CAB398 or IAB398", credit_points: 12, unit_type: "Core" },

  # CS Major Core (required for CS major)
  { code: "CAB201", name: "Object-Oriented Programming and Design", prerequisites: "IFB104 or ITD104 or MZB126 or MZB127 or EGD126 or MXB103 or EGB103 or EGD103", credit_points: 12, unit_type: "CS Major Core" },
  { code: "CAB222", name: "Networks", prerequisites: "IFB102 or ITD102 or EGB120", credit_points: 12, unit_type: "CS Major Core" },
  { code: "CAB302", name: "Agile Software Engineering", prerequisites: "CAB201", credit_points: 12, unit_type: "CS Major Core" },

  # CS Major General Option
  { code: "CAB210", name: "User Experience Fundamentals", prerequisites: "IFB103 or ITD103 or EGB101 or IGB120", credit_points: 12, unit_type: "CS Major General Option" },
  { code: "CAB230", name: "Web Computing", prerequisites: "IFB104 or ITD104 or EGB103 or EGD103", credit_points: 12, unit_type: "CS Major General Option" },
  { code: "CAB301", name: "Algorithms and Complexity", prerequisites: "CAB201 or ITD121", credit_points: 12, unit_type: "CS Major General Option" },
  { code: "CAB330", name: "Machine Learning for Decision Making", prerequisites: "DSB100 or DSB102 or CAB201 or IFB220", credit_points: 12, unit_type: "CS Major General Option" },

  # CS Major Advanced Option
  { code: "CAB401", name: "High Performance and Parallel Computing", prerequisites: "IFN584 or IFQ584 or (IFN563 and IFN564) or (IFQ563 and IFQ564) or CAB301", credit_points: 12, unit_type: "CS Major Advanced Option" },
  { code: "CAB403", name: "Systems Programming", prerequisites: "((CAB201 or ITD121) and CAB222) or CAB202 or EGB202", credit_points: 12, unit_type: "CS Major Advanced Option" },
  { code: "CAB420", name: "Machine Learning", prerequisites: "CAB201 or EGB202 or CAB202 or ITD121 or IFN501 or IFN556 or specific admissions", credit_points: 12, unit_type: "CS Major Advanced Option" },
  { code: "CAB432", name: "Cloud Computing", prerequisites: "CAB301 or CAB302 or INB370 or INB371 or IFN666 or IFQ666 or (IFN582 and IFN584) or (IFQ582 and IFQ584)", credit_points: 12, unit_type: "CS Major Advanced Option" },
  { code: "IFB343", name: "Secure Software Development", prerequisites: "IFB104 and IFB240", credit_points: 12, unit_type: "CS Major Advanced Option" },
  { code: "IFB452", name: "Blockchain Technology", prerequisites: "((IFB103 or ITD103) and (IFB104 or ITD104)) or (EGB103 or EGD103)) and (IFB240 or ITD240)) or complex alternatives", credit_points: 12, unit_type: "CS Major Advanced Option" },

  # Computer Science Elective
  { code: "CAB310", name: "Interaction and Experience Design", prerequisites: "CAB210", credit_points: 12, unit_type: "Computer Science Elective" },
  { code: "CAB340", name: "Cryptography", prerequisites: "IFB240", credit_points: 12, unit_type: "Computer Science Elective" },
  { code: "CAB440", name: "Network and Systems Administration", prerequisites: "CAB222 or CAB303 or INB251", credit_points: 12, unit_type: "Computer Science Elective" },
  { code: "CAB443", name: "Systems Security", prerequisites: "IFB103 and IAB246 (IAB246 concurrent ok)", credit_points: 12, unit_type: "Computer Science Elective" },
  { code: "CAB444", name: "Secure Network Architectures", prerequisites: "CAB222 and CAB443", credit_points: 12, unit_type: "Computer Science Elective" },

  # Information Systems
  { code: "DSB100", name: "Fundamentals of Data Science", prerequisites: "(CAB201 or ITD121) and (MZB151 or any MXB unit) (CAB201 concurrent ok)", credit_points: 12, unit_type: "Information Systems" },
  { code: "DSB101", name: "Introduction to Data Science and Visualisation", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "DSB102", name: "Introduction to Machine Learning", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "DSB200", name: "Applied Data Science", prerequisites: "DSB101 and DSB102 and IFB104", credit_points: 12, unit_type: "Information Systems" },
  { code: "DSB201", name: "Advanced Databases", prerequisites: "(IFB104 or ITD104 or EGB103) and (IFB105 or IFB130 or ITD105)", credit_points: 12, unit_type: "Information Systems" },
  { code: "DSB202", name: "Data Ethics and Society", prerequisites: "IFB104 and IFB105", credit_points: 12, unit_type: "Information Systems" },
  { code: "DSB301", name: "Advanced Visualisation and Data Science", prerequisites: "DSB102 and DSB200", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB201", name: "Modelling Techniques for Information Systems", prerequisites: "((IFB103 or ITD103) and (IFB105 or IFB130 or ITD105)) or IAB203", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB203", name: "Process Modelling", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB204", name: "Business Analysis for IT Systems", prerequisites: "IFB103", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB207", name: "Rapid Web Application Development", prerequisites: "(IFB103 or ITD103) and (IFB105 or ITD105 or IFB130)", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB230", name: "Design of Enterprise IoT", prerequisites: "IFB104 or ITD104 or EGB103", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB246", name: "Organisations and Security: Governance, Risk and Compliance", prerequisites: "IFB240 (concurrent ok)", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB251", name: "Software Engineering for Enterprise Systems", prerequisites: "((IFB104 or ITD104 or EGB103) and IFB201) or CAB201", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB260", name: "Social Technologies", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB305", name: "IT Strategy and Management", prerequisites: "IFB103 or ITD103", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB320", name: "Process Improvement", prerequisites: "IAB203", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB321", name: "Process Technologies", prerequisites: "IAB203", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB330", name: "Applied Internet of Things", prerequisites: "IFB104 or ITD104 or EGB103 or EGD103 and IFB102 or EGB202 or CAB202", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB353", name: "Data Analytics for Enterprise Systems", prerequisites: "((IFB104 or ITD104 or EGB103) and (IFB105 or IFB130 or ITD105)) or IAB251", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB401", name: "Enterprise Architecture", prerequisites: "IFB103 AND IFB105 AND (IAB251 OR IAB203)", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB402", name: "IT Consulting and Leadership", prerequisites: "IAB204 OR (192cps in various courses) OR specific admissions", credit_points: 12, unit_type: "Information Systems" },
  { code: "IAB410", name: "Enterprise Data & AI Governance", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "IGB120", name: "Introduction to Game Design", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "IGB180", name: "Games History, Culture and Psychology", prerequisites: "", credit_points: 12, unit_type: "Information Systems" },
  { code: "IGB220", name: "Fundamentals of Game Design", prerequisites: "IGB180 or INB180", credit_points: 12, unit_type: "Information Systems" },
  { code: "IGB283", name: "Game Engine Theory and Application", prerequisites: "CAB201", credit_points: 12, unit_type: "Information Systems" },
  { code: "IGB388", name: "Design and Development of Immersive Environments", prerequisites: "IGB200", credit_points: 12, unit_type: "Information Systems" },
  { code: "DXB212", name: "Tangible Media", prerequisites: "DXB211 or IFB104", credit_points: 12, unit_type: "Information Systems" },

  # Science Elective
  { code: "BVB101", name: "Foundations of Biology", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB103", name: "Evolution and the Diversity of Life", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB201", name: "Biological Processes", prerequisites: "BVB101 or BZB210 or ((BVB203 or BVB306) and admission to ST20)", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB202", name: "Experimental Design and Quantitative Methods", prerequisites: "SEB113 or MAB101 or MAB141 or MXB101 or MXB107 or (MZB103 and (MZB104 or MZB105))", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB204", name: "Ecological Science", prerequisites: "BVB101 or BVB102 or BVB103 or EVB102 or (admission to ST20 and completion of 96cp)", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB225", name: "Ecosystems and Biodiversity", prerequisites: "BVB101 or BVB102 or BVB103 or EVB102 or BZB210 or admission to ST20", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB305", name: "Microbiology and the Environment", prerequisites: "BVB201", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB306", name: "Plant Biology", prerequisites: "BVB201 or admission to ST20 or (BVB101 and BVB103 and admission to SV02)", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB313", name: "Molecular Ecology", prerequisites: "BVB204 or (BVB201 and admission to ST20) or (BVB101 and BVB103 and admission to SV02)", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB321", name: "Ecosystem Protection", prerequisites: "BVB204", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB328", name: "Applications in Biotechnology", prerequisites: "BVB317 or BVB201", credit_points: 12, unit_type: "Science Elective" },
  { code: "BVB330", name: "Synthetic Biology", prerequisites: "BVB317", credit_points: 12, unit_type: "Science Elective" },
  { code: "CLB100", name: "Global Change", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },
  { code: "CLB221", name: "Introduction to Climate Change", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },
  { code: "CLB222", name: "Oceans and Atmosphere", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },
  { code: "CLB333", name: "Dynamic Atmosphere", prerequisites: "PQB360 or CLB221", credit_points: 12, unit_type: "Science Elective" },
  { code: "PVB210", name: "Stellar Astrophysics", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },
  { code: "PVB220", name: "Cosmology", prerequisites: "", credit_points: 12, unit_type: "Science Elective" },

  # Mathematics Elective
  { code: "MXB100", name: "Introductory Calculus and Algebra", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB103", name: "Introductory Computational Mathematics", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB105", name: "Calculus and Differential Equations", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB106", name: "Linear Algebra", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB107", name: "Probability and Statistics", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB161", name: "Computational Explorations", prerequisites: "Admission to specific courses or 48cp of study", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB201", name: "Advanced Linear Algebra", prerequisites: "MXB106 and (MXB102 or Admission to ST20)", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB202", name: "Advanced Calculus", prerequisites: "MXB105 and MXB106", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB225", name: "Modelling with Differential Equations 1", prerequisites: "MXB105", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB226", name: "Computational Methods 1", prerequisites: "MXB103 and MXB201", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB241", name: "Probability and Stochastic Modelling 2", prerequisites: "MXB101 and MXB105", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB242", name: "Regression and Design", prerequisites: "MXB107", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB261", name: "Modelling and Simulation Science", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB322", name: "Partial Differential Equations", prerequisites: "(MXB201 and MXB202) or MXB225 or MXB221 or MAB413", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB325", name: "Modelling with Differential Equations 2", prerequisites: "MXB322 and (MXB225 or MXB221)", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB326", name: "Computational Methods 2", prerequisites: "MXB202 and (MXB226 or MXB222)", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB332", name: "Optimisation Modelling", prerequisites: "MXB232 or MAB315", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB334", name: "Operations Research for Stochastic Processes", prerequisites: "MXB232 and MXB241", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB341", name: "Statistical Inference", prerequisites: "MXB241 or MAB314", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MXB344", name: "Generalised Linear Models", prerequisites: "MXB242", credit_points: 12, unit_type: "Mathematics Elective" },
  { code: "MZB101", name: "Modelling with Introductory Calculus", prerequisites: "", credit_points: 12, unit_type: "Mathematics Elective" },

  # Work Integrated Learning
  { code: "SCB300", name: "Professional Practice", prerequisites: "Successfully completed 96cp and admission to IN01 or IN05 or ST01 or DS01 or MS01", credit_points: 12, unit_type: "Work Integrated Learning" },

  # QUT You units (shared across all courses - need to choose 4 = 24 CP)
  { code: "QUT001", name: "QUT You: Artificial Intelligence in the Real World", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT002", name: "QUT You: Walking on Country", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT003", name: "QUT You: Real Action for Real Change", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT004", name: "QUT You: Living and Working Collaboratively, Ethically, and Inclusively", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT005", name: "QUT You: Seeing Me, Seeing You: Skills for a Diverse World", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT006", name: "QUT You: The Art of Pitching", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT007", name: "QUT You: Fighting 'Fake News'", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT008", name: "QUT You: Think Like a Computer and Change the World", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT009", name: "QUT You: Data Science for Society", prerequisites: "", credit_points: 6, unit_type: "QUT You" },
  { code: "QUT010", name: "QUT You: People with Robots", prerequisites: "", credit_points: 6, unit_type: "QUT You" }
]

# Create IT subjects
it_subjects_data.each do |subject_data|
  it_course.subjects.create!(subject_data)
end

puts "\n=== Successfully seeded the database ===\n"
puts "\n--- #{law_course.name} ---"
puts "Created #{law_course.subjects.count} subjects"
puts "Core units: #{law_course.subjects.where(unit_type: 'Core').count} (#{law_course.subjects.where(unit_type: 'Core').sum(:credit_points)} CP)"
puts "General Law Electives: #{law_course.subjects.where(unit_type: 'General Law Elective').count}"
puts "Advanced Law Electives: #{law_course.subjects.where(unit_type: 'Advanced Law Elective').count}"
puts "QUT You units: #{law_course.subjects.where(unit_type: 'QUT You').count}"

puts "\n--- #{it_course.name} ---"
puts "Created #{it_course.subjects.count} subjects"
puts "Core units: #{it_course.subjects.where(unit_type: 'Core').count} (#{it_course.subjects.where(unit_type: 'Core').sum(:credit_points)} CP)"
puts "CS Major Core: #{it_course.subjects.where(unit_type: 'CS Major Core').count} (#{it_course.subjects.where(unit_type: 'CS Major Core').sum(:credit_points)} CP)"
puts "CS Major General Option: #{it_course.subjects.where(unit_type: 'CS Major General Option').count} (#{it_course.subjects.where(unit_type: 'CS Major General Option').sum(:credit_points)} CP)"
puts "CS Major Advanced Option: #{it_course.subjects.where(unit_type: 'CS Major Advanced Option').count} (#{it_course.subjects.where(unit_type: 'CS Major Advanced Option').sum(:credit_points)} CP)"
puts "Computer Science Elective: #{it_course.subjects.where(unit_type: 'Computer Science Elective').count}"
puts "Information Systems: #{it_course.subjects.where(unit_type: 'Information Systems').count}"
puts "Science Elective: #{it_course.subjects.where(unit_type: 'Science Elective').count}"
puts "Mathematics Elective: #{it_course.subjects.where(unit_type: 'Mathematics Elective').count}"
puts "Work Integrated Learning: #{it_course.subjects.where(unit_type: 'Work Integrated Learning').count}"
puts "QUT You units: #{it_course.subjects.where(unit_type: 'QUT You').count}"
