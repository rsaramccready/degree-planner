# README

## What is this?
This is a starter kit for use at hackathons. It comes with:

* Email/password authentication
* Tailwind on the frontend
* Simple API Authentication

# Getting Started
To get started with the Hackathon Starter Kit - run the following commands.

## Using Docker

Download and install Docker following this guide: https://docs.docker.com/get-started/get-docker/

Once you have downloaded docker run the following to set up the container

NOTE: if you update any dependencies you will need to re-run `docker compose build`

```bash
# build the application docker image
docker compose build

# Verify the image built
docker images | grep hackathon

# Run the application
docker compose up

# Alternatively if you prefer to skip compose and use direct docker commands

docker build -t hackathon .
# Verify the image built
docker images | grep hackathon

# Run the application
docker run --rm -it \
  -p 3000:3000 \
  -v .:/rails hackathon

# In another terminal
docker run --rm -it \
  -v .:/rails hackathon tailwind
```

Some other commands useful for local development with Docker via the compose plugin

```bash
# Access the Rails console
docker compose run --rm hackathon console

# Launch a shell in a new container
docker compose run --rm hackathon bash

# Launch a shell in the running container previously launched using `docker compose up`
docker compose exec hackathon bash

# Alternatively if you prefer to skip compose and use direct docker commands

# Access the Rails console
docker run --rm -it -v .:/rails hackathon console

# To access the Docker image CLI
docker run -it --entrypoint /bin/bash hackathon

# To access the currently running container CLI
docker ps

# From the command above find the running Container ID for hackathon
docker exec -it <CONTAINER_ID> bash
```

## Without Docker

You will need to install `sqlite` and `ruby`. You can follow the official Ruby on Rails guide here: https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails


### After system dependencies are installed

```bash
# This will install dependencies
bundle install

# This will setup the database & seed it
bin/rails db:prepare

# In one terminal run this - it will run a watcher for tailwind
bin/dev

# In another terminal run this - it will run the rails server
bin/rails server
```

## After Setup
Visit `localhost:3000` and login with either user found in `seeds.rb` or sign up with your own user.

# API

You can add API endpoints in `app/controllers/api/v1`, and by adding the routes in `routes.rb` in the `api` namespace.

## Usage

```bash
# Create a jwt
curl -X POST http://localhost:3000/api/v1/auth/login \n    -H "Content-Type: application/json" \n    -d '{"email": "your_email@mail.com", "password": "your_password"}'
```

Which will return the following payload:

```json
{
  "token":"YOUR_JWT",
  "user": {"id":1,"email":"your_email@mail.com","name":"Your Name"}
}
```

Then to make another request, use the JWT returned in the `token` in the `Authorization` header:

```bash
curl -X GET http://localhost:3000/api/v1/users/1 \
    -H "Authorization: Bearer YOUR_JWT"
```

Which will return

```json
{"id":1,"email":"your_email@mail.com","name":"Your name","created_at":"2024-07-16T05:08:48.108Z"}
```

```

## Run the test suite

### Using docker
```bash
# get a container shell first
docker compose run --rm hackathon bash
```

```bash
# Using Rake
bundle exec rake test

# Alternatively either of these work too
bin/test

bin/rails test

# To run a specific suite
bin/rails test test/controllers/users_controller_test.rb

# To run a test on a specific line
bin/rails test test/controllers/users_controller_test.rb:6
```

## Debugging

You can add `binding.pry` to any Ruby file or view to access the debugger. This will add a breakpoint in your terminal window to use for any debugging. If you have never used a Ruby debugger before, this article should help get you started: https://medium.com/@eddgr/the-absolute-beginners-guide-to-using-pry-in-ruby-b08681558fa6

If you are using docker to run the application you'll need to make sure docker attaches to the running container to open an interactive debugging shell.

After you've started the application using `docker compose up` you'll need to open a new shell in the same directory and run `docker attach $(docker compose ps -q hackathon)`.

From there you'll be attached to the application container and any active breakpoints will trigger in this attached shell env.
