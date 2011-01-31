require 'spec_helper'

module Anticipate
  describe Anticipate do
    include Anticipate
    
    before do
      @anticipator = mock("anticipator")
      @anticipator.stub!(:anticipate).and_yield
    end
    
    def anticipator
      @anticipator
    end
    
    describe "trying_every(n).seconds" do
      it "yields" do
        called = false
        trying_every(1).seconds { called = true }
        called.should be_true
      end
      
      it "overrides the interval" do
        @anticipator.should_receive(:anticipate).with(55, anything)
        trying_every(55).seconds {}
      end
      
      it "uses the default timeout" do
        @anticipator.should_receive(:anticipate).with(anything, default_tries)
        trying_every(66).seconds {}
      end
    end
    
    describe "failing_after(n).tries" do
      it "yields" do
        called = false
        failing_after(1).tries { called = true }
        called.should be_true
      end
      
      it "overrides the timeout" do
        @anticipator.should_receive(:anticipate).with(anything, 77)
        failing_after(77).tries {}
      end
      
      it "uses the default interval" do
        @anticipator.should_receive(:anticipate).with(default_interval, anything)
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
        @anticipator.should_receive(:anticipate).with(anything, 222)
        failing_after(222).tries.trying_every(111).seconds {}
      end
      
      it "overrides the interval" do
        @anticipator.should_receive(:anticipate).with(333, anything)
        failing_after(444).tries.trying_every(333).seconds {}
      end
    end
    
    describe "trying_every(x).seconds.failing_after(y).tries" do
      it "yields" do
        called = false
        trying_every(1).seconds.failing_after(2).tries { called = true }
        called.should be_true
      end
      
      it "overrides the timeout" do
        @anticipator.should_receive(:anticipate).with(anything, 666)
        trying_every(555).seconds.failing_after(666).tries {}
      end
      
      it "overrides the interval" do
        @anticipator.should_receive(:anticipate).with(777, anything)
        trying_every(777).seconds.failing_after(888).tries {}
      end
    end
  end
end