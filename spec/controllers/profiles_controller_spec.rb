RSpec.describe ProfilesController do
  describe "GET #show" do
    let(:user)            { create(:confirmed_user) }
    let(:params)          { { id: user.id } }
    let(:show_profile_input) { { id: params.fetch(:id).to_s } }

    let(:show_profile_context) do
      Interactor::Context.new(errors: :val, user: user)
    end

    before(:example) do
      allow(ShowProfile).to receive(:call).with(show_profile_input).
        and_return(show_profile_context)
    end

    before do
      authenticate
    end

    context "when succesful" do
      it "calls the ShowProfile interactor" do
        expect(ShowProfile).to receive(:call)
        get :show, params
      end

      it "returns HTTP status 200" do
        get :show, params
        expect(response).to have_http_status(200)
      end

      it "render the user as JSON" do
        get :show, params
        expect(serialize(user)).to eq(response.body)
      end
    end

    context "when ShowProfile fails" do
      let(:show_profile_context) do
        double(:context, errors: "invalid", success?: false)
      end

      it "returns HTTP status 404" do
        get :show, params
        expect(response).to have_http_status(404)
      end

      it "renders an error" do
        get :show, params
        expect(response.body).to eq("invalid")
      end
    end
  end

  describe "GET #index" do
    let(:user)  { create(:confirmed_user) }
    let(:user2) { create(:confirmed_user) }
    let(:user3) { create(:confirmed_user) }

    let(:index_profile_context) do
      Interactor::Context.new(errors:   :val,
                              profiles: [user, user2, user3])
    end

    before(:example) do
      allow(IndexProfile).to receive(:call).and_return(index_profile_context)
    end

    before do
      authenticate
    end

    context "when succesful" do
      it "calls the IndexProfile interactor" do
        expect(IndexProfile).to receive(:call)
        get :index
      end

      it "returns HTTP status 200" do
        get :index
        expect(response).to have_http_status(200)
      end

      it "render the profiles as JSON" do
        get :index
        expect(response.body).
          to eq([serialize(user), serialize(user2), serialize(user3)])
      end
    end

    context "when IndexProfile fails" do
      let(:index_profile_context) do
        double(:context, errors: "internal server error", success?: false)
      end

      it "returns HTTP status 500" do
        get :index
        expect(response).to have_http_status(500)
      end

      it "renders an error" do
        get :index
        expect(response.body).to eq("internal server error")
      end
    end
  end
end