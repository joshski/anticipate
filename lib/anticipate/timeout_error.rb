module Anticipate
  class TimeoutError < RuntimeError
    def initialize(interval, tries, last_error)
      @interval, @tries, @last_error =
        interval, tries, last_error
    end
    
    def to_s
      "Timed out after #{@tries} tries" +
      " (tried every #{seconds(@interval)})" +
      "\n#{@last_error}"
    end
    
    def backtrace
      @last_error.backtrace
    end
    
    private
    
    def seconds(amount)
      amount == 1 ? "1 second" : "#{amount} seconds"
    end
  end
end