require 'spec_helper'

module Anticipate
  describe Anticipator do
    before do
      @sleeper = mock("sleeper")
      @sleeper.stub!(:sleep)
      @anticipator = Anticipator.new(@sleeper)
    end
    
    describe "#anticipate" do
      
      describe "when the block eventually stops raising a StandardError" do
        it "sleeps the given interval between tries" do
          @sleeper.should_receive(:sleep).with(1).exactly(8).times
          tries = 0
          @anticipator.anticipate(1,9) do
            raise "fail" unless (tries += 1) == 9
          end
          tries.should == 9
        end
        
        it "does not raise" do
          tries = 0
          lambda {
            @anticipator.anticipate(1,2) do
              raise "fail" unless (tries += 1) == 2
            end
          }.should_not raise_error
        end
      end
      
      describe "when the block eventually stops raising an Exception (that is not a StandardError)" do
        
        it "sleeps the given interval between tries" do
          @sleeper.should_receive(:sleep).with(1).exactly(8).times
          tries = 0
          @anticipator.anticipate(1,9) do
            raise Exception.new unless (tries += 1) == 9
          end
          tries.should == 9
        end
        
      end
        
      describe "when the block always raises" do
        describe "when waiting for one second" do        
          it "raises a TimeoutError, with the last error message" do
            tries = 0
            lambda {
              @anticipator.anticipate(1,2) { raise (tries += 1).to_s }
            }.should raise_error(TimeoutError,
                      "Timed out after 2 tries (tried every 1 second)\n3")
          end
        end
        
        describe "when waiting for any other number of seconds" do
          it "raises a TimeoutError, with the last error message" do
            tries = 0
            lambda {
              @anticipator.anticipate(2,3) { raise (tries += 1).to_s }
            }.should raise_error(TimeoutError,
                      "Timed out after 3 tries (tried every 2 seconds)\n4")
          end
        end
      end
      
      describe "when the block never raises" do
        it "does not raise" do
          lambda {
            @anticipator.anticipate(1,2) do
            end
          }.should_not raise_error
        end
      end
    end

  end
end