RSpec.describe CreateGroup do
  describe ".call" do
    let(:user) do
      create(:confirmed_user)
    end

    let(:group_params) do
      {
        name:     "Weasley's Kneesleys",
        city:     "Baltimore",
        state:    "MD",
        country:  "USA",
        facebook: "http://facebook.com/weasley",
        twitter:  "http://twitter.com/weasley"
      }
    end

    subject do
      described_class.call(user: user, group_params: group_params)
    end

    context "when successful" do
      it "returns a successful context" do
        is_expected.to be_a_success
      end

      it "creates a new group" do
        expect(subject.resource).to be_a Group
      end
    end

    context "when group is not saved" do
      before do
        group_params["name"] = ""
      end

      it "fails" do
        is_expected.to be_a_failure
      end

      it "returns an error" do
        expect(subject.errors.messages).to eq(name: ["can't be blank"])
      end
    end

    context "when group_params are not provided" do
      subject do
        described_class.call(group_params: nil)
      end

      it "fails" do
        is_expected.to be_a_failure
      end

      it "returns an error" do
        expect(subject.errors).to eq("invalid input")
      end
    end

    context "when user is not provided" do
      subject do
        described_class.call(group_params: group_params, user: nil)
      end

      it "fails" do
        is_expected.to be_a_failure
      end

      it "returns an error" do
        expect(subject.errors).to eq("invalid input")
      end
    end
  end
end
