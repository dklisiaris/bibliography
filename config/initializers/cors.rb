# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      'https://bibliography.gr',
      'https://www.bibliography.gr',
      'http://bibliography.gr',
      'http://www.bibliography.gr'
    )

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end

  if Rails.env.development?
    allow do
      origins(
        /\Ahttp:\/\/localhost(:\d+)?\z/,
        /\Ahttp:\/\/127\.0\.0\.1(:\d+)?\z/
      )

      resource '*',
               headers: :any,
               methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
end
