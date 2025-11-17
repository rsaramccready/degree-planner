# Rails Hackathon Starter Kit

## Overview
A Rails 7.1 application providing both a web interface and JSON API for user management. Originally created as a hackathon starter template.

## Tech Stack
- **Framework**: Rails 7.1.3
- **Ruby**: 3.2.4
- **Database**: SQLite3 (in development)
- **Frontend**: Tailwind CSS, Hotwire (Turbo + Stimulus)
- **Authentication**:
  - Web: Session-based with `has_secure_password`
  - API: JWT tokens
- **Server**: Puma

## Project Structure

### Models
- `User` (app/models/user.rb)
  - Fields: email, name, password_digest
  - Validations: email presence/uniqueness, password minimum 7 characters
  - Uses bcrypt for password hashing

### Controllers

#### Web Controllers
- `ApplicationController` - Base controller with session authentication
- `SessionsController` - Login/logout for web interface
- `UsersController` - User signup and profile management

#### API Controllers (app/controllers/api/v1/)
- `Api::V1::ApiController` - Base API controller with JWT authentication
- `Api::V1::AuthController` - JWT login and token refresh
- `Api::V1::UsersController` - User CRUD operations

### Authentication

**Web (Session-based):**
- Uses `session[:user_id]`
- `current_user` helper available in controllers/views
- `require_authenticated_user` before_action protects routes

**API (JWT-based):**
- Login: `POST /api/v1/auth/login` with email/password
- Returns JWT token valid for 24 hours
- Include in requests: `Authorization: Bearer <token>`
- Tokens signed with `Rails.application.credentials.secret_key_base`

## API Endpoints

```
POST   /api/v1/auth/login      - Login (returns JWT + user)
POST   /api/v1/auth/refresh    - Refresh token (requires JWT)
GET    /api/v1/users/:id       - Get user details (requires JWT)
POST   /api/v1/users           - Create user (returns JWT + user)
PATCH  /api/v1/users/:id       - Update user (requires JWT, own profile only)
```

## Running the Application

**Local:**
```bash
bundle install
bin/rails db:migrate
bin/rails server
```

**Docker:**
```bash
docker compose build  # Required after Gemfile changes
docker compose up
```

## Key Configuration

- **CORS**: Configured in `config/initializers/cors.rb` (currently allows all origins for development)
- **Routes**: Web and API routes separated in `config/routes.rb`
- **Database**: SQLite schema in `db/schema.rb`

## Important Notes

- JWT secret uses Rails' `secret_key_base` - do not expose in production
- CORS is currently set to `origins '*'`
- API controllers skip CSRF protection with `skip_before_action :verify_authenticity_token`
- Docker requires rebuild after Gemfile changes to install new gems
