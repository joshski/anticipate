lib = File.dirname(__FILE__)
$:.unshift(lib) unless $:.include?(lib) || $:.include?(File.expand_path(lib))

require 'anticipate/anticipator'

module Anticipate
  VERSION = '0.0.1'
  
  def anticipator
    Anticipator.new(Kernel)
  end  
  
  def default_tries
    @default_tries ||= 1
  end
  
  def default_interval
    @default_interval ||= 0.1
  end
  
  def trying_every(amount)
    anticipation.trying_every(amount)
  end
  
  def failing_after(amount)
    anticipation.failing_after(amount)
  end
  
  private
  
  def anticipation
    Anticipation.new(anticipator, default_interval, default_tries)
  end
  
  class Term
    def initialize(anticipator, interval, timeout)
      @anticipator, @interval, @timeout = anticipator, interval, timeout
    end
    
    private
    
    def exec
      @anticipator.anticipate(@interval, @timeout) do
        yield
      end
    end
    
    def chain
      Anticipation.new(@anticipator, @interval, @timeout)
    end
  end
    
  class TimeUnit < Term
    def seconds
      block_given? ? exec { yield } : chain
    end
  end
  
  class CountUnit < Term
    def tries
      block_given? ? exec { yield } : chain
    end
  end

  class Anticipation < Term
    def trying_every(amount)
      TimeUnit.new(@anticipator, amount, @timeout)
    end
    
    def failing_after(amount)
      CountUnit.new(@anticipator, @interval, amount)
    end
  end
end