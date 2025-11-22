# QUT Degree Planner

## What is this?
A web application that helps QUT students plan their degree by automatically scheduling subjects based on prerequisites, credit point requirements, and semester availability. The planner intelligently handles complex prerequisite logic (OR/AND conditions) and generates an optimal semester-by-semester study plan.

### Features
* Course selection (Law, Computer Science, Information Technology)
* Subject selection with prerequisite validation
* Automatic semester planning with topological sorting
* GPA calculation for completed subjects
* Support for complex prerequisites (OR/AND logic)
* Difficulty modes (Easy, Balanced, Hard) for different study loads
* Responsive UI with Tailwind CSS

## Tech Stack
* Ruby on Rails 8.1.1
* Ruby 3.2.4+
* SQLite (development) / PostgreSQL (production)
* Tailwind CSS
* Turbo & Stimulus

# Getting Started

## Local Setup (Recommended)

### Prerequisites
You will need to install Ruby and SQLite. Follow the official Ruby on Rails guide: https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd degree-planner

# Install dependencies
bundle install

# Setup the database and seed with course data
bin/rails db:prepare

# Start the development server
bin/rails server
```

Visit `http://localhost:3000` to access the application.

### Development with Tailwind

If you're making CSS changes, run the Tailwind watcher in a separate terminal:

```bash
bin/dev
```

This will watch for Tailwind CSS changes and recompile automatically.

## Using Docker

Download and install Docker: https://docs.docker.com/get-started/get-docker/

**NOTE**: If you update any dependencies, you'll need to re-run `docker compose build`

```bash
# Build the application docker image
docker compose build

# Run the application
docker compose up
```

Visit `http://localhost:3000` to access the application.

### Useful Docker Commands

```bash
# Access the Rails console
docker compose run --rm hackathon console

# Launch a shell in a new container
docker compose run --rm hackathon bash

# Launch a shell in the running container
docker compose exec hackathon bash
```

## Database Setup

The seed file includes:
- QUT Law, Computer Science, and Information Technology courses
- All subjects with prerequisites, credit points, and semester availability
- Sample user accounts

If you need to reset the database:

```bash
bin/rails db:reset
```

## How It Works

### Prerequisite Parsing
The application automatically parses complex prerequisite strings like:
- Simple: `IFB104` (requires one subject)
- OR logic: `IFB104 or EGB103` (requires any one)
- AND logic: `IFB104 and IFB240` (requires both)
- Complex: `(IFN582 and IFN584) or CAB301` (requires both from first group OR the single subject)

### Planning Algorithm
The planner uses a topological sort (Kahn's algorithm) combined with custom prerequisite checking to:
1. Build a dependency graph of subjects
2. Schedule subjects when prerequisites are met
3. Track credit points for CP-based prerequisites
4. Optimize scheduling based on difficulty preference
5. Handle OR/AND prerequisite logic correctly

## Running Tests

```bash
# Run all tests
bin/rails test

# Run a specific test file
bin/rails test test/controllers/degree_planner_controller_test.rb

# Run a specific test
bin/rails test test/controllers/degree_planner_controller_test.rb:6
```

## Debugging

You can add `binding.pry` to any Ruby file to access the debugger. This will add a breakpoint in your terminal.

For more info on using Pry: https://medium.com/@eddgr/the-absolute-beginners-guide-to-using-pry-in-ruby-b08681558fa6

### Debugging with Docker

If using Docker, you'll need to attach to the running container:

```bash
# Start the application
docker compose up

# In another terminal, attach to the container
docker attach $(docker compose ps -q hackathon)
```

Any breakpoints will now trigger in this attached shell.

## Deployment

The application is configured for deployment on Render with PostgreSQL. See `config/database.yml` for production configuration.

## Contributing

When adding new subjects or courses:
1. Update the seed file with course/subject data
2. Ensure prerequisites follow the expected format
3. Run the prerequisite parsing script if needed: `bin/rails runner tmp/parse_prerequisites.rb`

## License

This project was built using the Tanda Hackathon Starter Kit as a foundation.
