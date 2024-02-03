require "rails_helper"

RSpec.describe "Entries", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  before { sign_in(current_user) }
  before { Current.user = current_user }

  describe "GET /index" do
    it "responds with success" do
      get entries_path

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    subject { FactoryBot.create(:entry, user: current_user) }

    it "responds with success" do
      get entry_path(subject)

      expect(response).to be_successful
    end

    context "with entry owned by other user" do
      subject { FactoryBot.create(:entry) }

      it "responds with not found page" do
        get entry_path(subject)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /new" do
    it "responds with success" do
      get new_entry_path

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    before { FactoryBot.create(:category) }

    def post_create_entry(params)
      post entries_path, params: {
        entry: params
      }
    end

    context "with valid params" do
      it "creates a new entry" do
        expect do
          params =
            FactoryBot
              .attributes_for(:entry, category_id: Category.pluck(:id).last)
              .except(:token)

          post_create_entry(params)
        end.to change { Entry.count }.by(1)
      end
    end
  end

  describe "GET /edit" do
    subject { FactoryBot.create(:entry, user: current_user) }

    it "responds with success" do
      get edit_entry_path(subject)

      expect(response).to be_successful
    end

    context "with entry owned by other user" do
      subject { FactoryBot.create(:entry) }

      it "responds with success" do
        get edit_entry_path(subject)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT /update" do
    def put_update_entry(entry, params)
      put entry_path(entry), params: { entry: params }
    end

    subject { FactoryBot.create(:entry, user: current_user) }

    context "with valid params" do
      it "updates the entry" do
        expect do
          put_update_entry(subject, {
            description: "my new title",
            value: "$ 1.234,56"
          })
        end.to(change { subject.reload.updated_at })

        expect(subject.reload.description).to eq("my new title")
        expect(subject.reload.value).to eq(BigDecimal("1234.56"))
      end
    end

    context "with entry owned by other user" do
      subject { FactoryBot.create(:entry) }

      context "with valid params" do
        it "responds with page not found" do
          put_update_entry(subject, {
            description: "my new title",
            value: "$ 1.234,56"
          })

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes the entry" do
      subject = FactoryBot.create(:entry, user: current_user)

      expect do
        delete entry_path(subject)
      end.to change { Entry.count }.by(-1)
    end

    context "with entry owned by other user" do
      subject { FactoryBot.create(:entry) }

      it "responds with page not found" do
        delete entry_path(subject)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
