require 'spec_helper'

module Anticipate
  describe Anticipate do
    include Anticipate
    
    let :anticipator do
      mock("anticipator")
    end
    
    before do
      anticipator.stub!(:anticipate).and_yield
    end
    
    describe "trying_every(n).seconds" do
      it "yields" do
        called = false
        trying_every(1).seconds { called = true }
        called.should be_true
      end
      
      it "overrides the interval" do
        anticipator.should_receive(:anticipate).with(55, anything)
        trying_every(55).seconds {}
      end
      
      it "uses the default timeout" do
        anticipator.should_receive(:anticipate).with(anything, default_tries)
        trying_every(66).seconds {}
      end
    end
    
    describe "sleeping(n).seconds.between_tries" do
      it "yields" do
        called = false
        sleeping(1).seconds.between_tries { called = true }
        called.should be_true        
      end
      
      it "overrides the interval" do
        anticipator.should_receive(:anticipate).with(77, anything)
        trying_every(77).seconds {}
      end
      
      it "uses the default timeout" do
        anticipator.should_receive(:anticipate).with(anything, default_tries)
        trying_every(88).seconds {}
      end
    end
    
    describe "failing_after(n).tries" do
      it "yields" do
        called = false
        failing_after(1).tries { called = true }
        called.should be_true
      end
      
      it "overrides the timeout" do
        anticipator.should_receive(:anticipate).with(anything, 77)
        failing_after(77).tries {}
      end
      
      it "uses the default interval" do
        anticipator.should_receive(:anticipate).with(default_interval, anything)
        failing_after(88).tries {}
      end
    end
    
    describe "failing_after(x).tries.trying_every(y).seconds" do
      it "yields" do
        called = false
        failing_after(2).tries.trying_every(1).seconds { called = true }
        called.should be_true
      end
      
      it "overrides the timeout" do
        anticipator.should_receive(:anticipate).with(anything, 1)
        failing_after(anything).tries.trying_every(1).seconds {}
      end
      
      it "overrides the interval" do
        anticipator.should_receive(:anticipate).with(2, anything)
        failing_after(anything).tries.trying_every(2).seconds {}
      end
    end
    
    describe "trying_every(x).seconds.failing_after(y).tries" do
      it "yields" do
        called = false
        trying_every(1).seconds.failing_after(2).tries { called = true }
        called.should be_true
      end
      
      it "overrides the timeout" do
        anticipator.should_receive(:anticipate).with(anything, 3)
        trying_every(anything).seconds.failing_after(3).tries {}
      end
      
      it "overrides the interval" do
        anticipator.should_receive(:anticipate).with(4, anything)
        trying_every(4).seconds.failing_after(anything).tries {}
      end
    end
    
    describe "sleeping(x).seconds.between_tries.failing_after(y).tries" do
      it "yields" do
        called = false
        sleeping(1).seconds.between_tries.failing_after(2).tries { called = true }
        called.should be_true
      end
      
      it "overrides the timeout" do
        anticipator.should_receive(:anticipate).with(anything, 5)
        sleeping(anything).seconds.between_tries.failing_after(5).tries {}
      end
      
      it "overrides the interval" do
        anticipator.should_receive(:anticipate).with(6, anything)
        trying_every(6).seconds.failing_after(anything).tries {}
      end
    end
  end
end