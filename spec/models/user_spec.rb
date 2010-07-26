require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  subject do
    User.new
  end

  it "has vurls" do
    should respond_to(:vurls)
  end

  context "before creation" do
    it "generates a claim code before saving" do
      subject.should_receive(:generate_claim_code)
      subject.save(false)
    end
    it "sets the name to Anonymous" do
      subject.should_receive(:set_default_name)
      subject.save(false)
    end
    it "creates an api token" do
      subject.should_receive(:generate_api_token)
      subject.save(false)
    end
  end

  describe "#set_default_name" do
    it "does not set the name to Anonymous if the user already has a name" do
      subject.name = "API"
      subject.save_without_validation
      subject.name.should == "API"
    end
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
    it "delegates to new_hash" do
      subject.should_receive(:new_hash).and_return('a8d6777a8f898e09c08870f070')
      subject.send(:generate_claim_code)
    end
    it "uses the first 8 characters" do
      subject.stub(:new_hash).and_return('a8d6777a8f898e09c08870f070')
      subject.send(:generate_claim_code)
      subject.claim_code.should == 'a8d6777a'
    end
  end

  describe "#generate_api_token" do
    it "delegates to new_hash" do
      subject.should_receive(:new_hash).and_return('a8d6777a8f898e09c08870f070')
      subject.generate_api_token
    end
    it "uses the first 8 characters" do
      subject.stub(:new_hash).and_return('a8d6777a8f898e09c08870f070')
      subject.generate_api_token
      subject.api_token.should == 'a8d6777a'
    end
  end
end
