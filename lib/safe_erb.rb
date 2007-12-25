# SafeERB

require 'safe_erb/common'

if Rails::VERSION::MAJOR >= 2
  require 'safe_erb/rails_2'
else
  require 'safe_erb/rails_1'
end
