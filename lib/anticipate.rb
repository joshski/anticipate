lib = File.dirname(__FILE__)
$:.unshift(lib) unless $:.include?(lib) || $:.include?(File.expand_path(lib))

require 'anticipate/anticipator'
require 'anticipate/dsl'

module Anticipate
  VERSION = '0.1.1'
  
  include DSL
end