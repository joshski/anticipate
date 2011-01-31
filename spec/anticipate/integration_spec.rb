require 'spec_helper'

module Anticipate
  describe Anticipate, "with default options" do
    include Anticipate

    it "raises when a block continually raises" do
      raises = []
      lambda {
        trying_every(0.01).seconds.failing_after(5).tries {
          raise (raises << Time.now).to_s
        }
      }.should raise_error(TimeoutError)
      raises.size.should == 6
      total_time = raises.last - raises.first
      total_time.should > 0.05
      total_time.should < 0.06
    end

    it "continues when a block stops raising" do
      raises = 0
      lambda {
        trying_every(0.01).seconds.failing_after(3).tries {
          raise (raises += 1).to_s unless raises == 2
        }
      }.should_not raise_error
      raises.should == 2
    end
  end
  
  describe Anticipate, "with overridden tries" do
    include Anticipate
    
    def default_tries
      5
    end

    it "uses the overridden tries" do
      raises = []
      lambda {
        trying_every(0.01).seconds {
          raise (raises << Time.now).to_s
        }
      }.should raise_error(TimeoutError)
      raises.size.should == 6
      total_time = raises.last - raises.first
      total_time.should > 0.05
      total_time.should < 0.06
    end
  end
  
  describe Anticipate, "with overridden interval" do
    include Anticipate
    
    def default_interval
      0.01
    end

    it "uses the overridden interval" do
      raises = []
      lambda {
        failing_after(5).tries {
          raise (raises << Time.now).to_s
        }
      }.should raise_error(TimeoutError)
      raises.size.should == 6
      total_time = raises.last - raises.first
      total_time.should > 0.05
      total_time.should < 0.06
    end
  end
end