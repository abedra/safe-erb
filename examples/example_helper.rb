require File.expand_path(File.join(File.dirname(__FILE__), "../" "lib", "safe_erb.rb"))

gem "spicycode-micronaut", ">= 0.2.4"
require 'micronaut'

def not_in_editor?
  ['TM_MODE', 'EMACS', 'VIM'].all? { |k| !ENV.has_key?(k) }
end

Micronaut.configure do |c|
  c.alias_example_to :fit, :focused => true
  c.alias_example_to :xit, :disabled => true
  c.mock_with :mocha
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true
end
