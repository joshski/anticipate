module Anticipate
  module DSL
   
    def trying_every(amount)
      anticipation.trying_every(amount)
    end

    def failing_after(amount)
      anticipation.failing_after(amount)
    end

    def sleeping(amount)
      anticipation.sleeping(amount)
    end

    def default_tries
      @default_tries ||= 1
    end

    def default_interval
      @default_interval ||= 0.1
    end

    private

    def anticipator
      Anticipator.new(Kernel)
    end  
    
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

    class TryingEvery < Term
      def seconds
        block_given? ? exec { yield } : chain
      end
    end

    class FailingAfter < Term
      def tries
        block_given? ? exec { yield } : chain
      end
    end

    class AfterSleep < Term
      def between_tries
        block_given? ? exec { yield } : chain
      end
    end

    class Sleeping < Term
      def seconds
        AfterSleep.new(@anticipator, @interval, @timeout)
      end
    end

    class Anticipation < Term
      def trying_every(amount)
        TryingEvery.new(@anticipator, amount, @timeout)
      end

      def failing_after(amount)
        FailingAfter.new(@anticipator, @interval, amount)
      end

      def sleeping(amount)
        Sleeping.new(@anticipator, @interval, amount)
      end
    end
    
  end
end