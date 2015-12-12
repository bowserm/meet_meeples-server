RSpec.describe DeleteUser do
  describe ".call" do
    let(:user) { create(:confirmed_user, id: 700) }

    context "when successful" do
      subject do
        DeleteUser.call(id: user.id)
      end

      it "returns a successful context" do
        is_expected.to be_a_success
      end

      it "deletes the user record" do
        expect(subject.user.destroyed?).to be_truthy
      end
    end

    context "when user id is invalid" do
      subject do
        DeleteUser.call(id: nil)
      end

      it "fails" do
        is_expected.to be_a_failure
      end

      it "returns an error" do
        expect(subject.error).to eq("invalid input")
      end
    end
  end
end
