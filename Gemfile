source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "importmap-rails"

# Templating
gem "slim-rails", "~> 4.0"

# Soft delete
gem "discard", "~> 1.4"

# Paginación
gem "kaminari", "~> 1.2"

# Generación de PDF (pure Ruby, sin dependencias de sistema)
gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.2"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
