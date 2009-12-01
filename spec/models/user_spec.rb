require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  subject do
    User.new
  end

  it "has vurls" do
    should respond_to(:vurls)
  end

  it "generates a claim code before saving" do
    subject.should_receive(:generate_claim_code)
    subject.save_without_validation
  end

  it "sets the name to Anonymous" do
    subject.should_receive(:set_default_name)
    subject.save_without_validation
  end

  it "does not set the name to Anonymous if the user already has a name" do
    subject.name = "API"
    subject.save_without_validation
    subject.name.should == "API"
  end

  describe "#claimed?" do
    before { @user = User.new }
    subject { @user.claimed? }
    it "returns true if the claim code is empty" do
      @user.claim_code = nil
      should be_true
    end
    it "returns false with a claim code" do
      @user.claim_code = 'something'
      should be_false
    end
  end

  describe "#unclaimed?" do
    before { @user = User.new }
    subject { @user.unclaimed? }
    it "returns the opposite of claimed" do
      @user.stub!(:claimed?).and_return(false)
      should be_true
    end
  end

  describe "#generate_claim_code" do
    # TODO: Find a decent way to test this implementation
  end
end
