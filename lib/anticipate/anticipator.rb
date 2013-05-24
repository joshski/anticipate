require 'anticipate/timeout_error'

module Anticipate
  class Anticipator
    def initialize(sleeper)
      @sleeper = sleeper
    end
  
    def anticipate(interval, tries)
      count = -1
      begin
        yield
        return
      rescue Exception => e
        if (count += 1) == tries
          raise TimeoutError.new(interval, tries, e)
        end
        @sleeper.sleep interval
        retry
      end
    end
  end
end