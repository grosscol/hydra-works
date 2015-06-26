source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation', ref: '0dfe4f43e115ec5f83b3dab046e557d0d2afd4e0'
gem 'active-fedora', github: 'projecthydra/active_fedora', ref: 'd6784e23a7ad324e2d03a23c7c063fc888b89398'
gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm', ref: '11f460145bcdd831ce0b8f05fb8ca74f8981f378'
gem 'hydra-derivatives', github: 'projecthydra/hydra-derivatives', ref: '7a8377c12ba1697f825cef9f5b2cd3ec7b844228'
gem 'slop', '~> 3.6' # For byebug

unless ENV['CI']
  gem 'pry'
  gem 'pry-byebug'
  gem 'byebug'
end
