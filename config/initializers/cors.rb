# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow requests from any origin in development
    # In production, replace '*' with your actual frontend domain(s)
    origins '*'

    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false,
      max_age: 600
  end
end
