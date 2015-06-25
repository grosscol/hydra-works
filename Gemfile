source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation', ref: '0dfe4f4'
gem 'active-fedora', github: 'projecthydra/active_fedora', ref: 'd6784e23a7ad32'
gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm', ref: '11f460145bcdd8'
gem 'hydra-derivatives', github: 'projecthydra/hydra-derivatives', ref: '7a8377c12b'
gem 'slop', '~> 3.6' # For byebug

unless ENV['CI']
  gem 'pry'
  gem 'pry-byebug'
  gem 'byebug'
end
