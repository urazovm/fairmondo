# Load DSL and Setup Up Stages
require 'capistrano/setup'

require 'capistrano/rbenv'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'

# Includes tasks from other gems included in your Gemfile
require 'capistrano/rails'

# Console
require 'capistrano/console'

require 'capistrano/sidekiq'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
