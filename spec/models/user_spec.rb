require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  subject do
    User.new
  end

  context "validations" do

    context "on website" do
      it { should allow_value("http://veez.us").for(:website) }
      it { should allow_value("http://blog.veez.us").for(:blog) }
      it { should allow_value("veez.us").for(:website) }
      it { should allow_value("blog.veez.us").for(:blog) }
    end

    context "on email" do
      it { should allow_value('hey@example.com').for(:email) }
      it { should allow_value('user+sitename@example.com').for(:email) }
      it { should_not allow_value('@example.com').for(:email) }
      it { should_not allow_value('http://something.com').for(:email) }
      it "doesn't require an email to create a user" do
        subject.valid?
        should have(0).errors_on(:email)
      end
      it "requires an email to update a user" do
        user = Fabricate(:user, :email => nil)
        user.valid?
        user.should have(1).error_on(:email)
      end
    end
  end

  describe "#claim" do
    let(:user) { User.find(Fabricate(:user).id) }
    it "requires a password" do
      user.claim(:password => '')
      user.should have(1).error_on(:password)
    end
    it "clears the claim code" do
      user.claim({})
      user.claim_code.should be_nil
    end
  end

  it "has vurls" do
    should respond_to(:vurls)
  end

  context "before creation" do
    it "generates a claim code before saving" do
      subject.should_receive(:generate_claim_code)
      subject.save
    end
    it "sets the name to Anonymous" do
      subject.should_receive(:set_default_name)
      subject.save
    end
    it "creates an api token" do
      subject.should_receive(:generate_api_token)
      subject.save
    end
  end

  describe "#set_default_name" do
    it "does not set the name to Anonymous if the user already has a name" do
      subject.name = "API"
      subject.save
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

  describe "#set_default_password" do
    context "when there is no password or crypted password" do
      it "sets a default password" do
        subject.send(:set_default_password)
        subject.password.should_not be_blank
      end
    end
    context "when a password is being set" do
      it "doesn't set the default password" do
        subject.password = 'a password'
        subject.send(:set_default_password)
        subject.password.should == 'a password'
      end
    end
    context "when a password has previously been set" do
      it "doesn't set the default password" do
        subject.crypted_password = 'a crypted password'
        subject.should_not_receive(:password=)
        subject.send(:set_default_password)
      end
    end
  end
end
