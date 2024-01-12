require "rails_helper"

RSpec.describe "Categories", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  before { sign_in(current_user) }

  describe "GET /index" do
    it "responds with success" do
      get categories_path

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "responds with success" do
      get new_category_path

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid params" do
      it "creates a new user's category" do
        expect do
          post categories_path, params: {
            category: {
              name: Faker::Lorem.word
            }
          }
        end.to change { Category.where(user_id: current_user).count }.by(1)
      end
    end

    context "with invalid params" do
      it "responds with error" do
        post categories_path, params: {
          category: {
            name: nil
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /edit" do
    before do
      allow(Current).to receive(:user).and_return(current_user)
    end

    context "when user's category" do
      subject { FactoryBot.create(:category, user: current_user) }

      it "responds with success" do
        get(edit_category_path(subject))

        expect(response).to be_successful
      end
    end

    context "when other user's category" do
      subject { FactoryBot.create(:category, user: FactoryBot.create(:user)) }

      it "responds with page not found" do
        get(edit_category_path(subject))

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when system's category" do
      subject { FactoryBot.create(:category) }

      it "responds with page not found" do
        get(edit_category_path(subject))

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT /update" do
    before do
      allow(Current).to receive(:user).and_return(current_user)
    end

    context "when user's category" do
      subject { FactoryBot.create(:category, user: current_user) }

      before do
        put(category_path(subject), params: {
          category: {
            name: "new category name"
          }
        })
      end

      it "updates the category" do
        expect(subject.reload.name).to eq("new category name")
      end
    end

    context "when other user's category" do
      subject { FactoryBot.create(:category, user: FactoryBot.create(:user)) }

      it "responds with page not found" do
        put(category_path(subject), params: {
          category: {
            name: "new category name"
          }
        })

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when system's category" do
      subject { FactoryBot.create(:category) }

      it "responds with page not found" do
        put(category_path(subject), params: {
          category: {
            name: "new category name"
          }
        })

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      allow(Current).to receive(:user).and_return(current_user)
    end

    context "when user's category" do
      subject { FactoryBot.create(:category, user: current_user) }

      it "discards the category" do
        expect do
          delete(category_path(subject))
        end.to change { Category.discarded.count }.by(1)
      end
    end

    context "when other user's category" do
      subject { FactoryBot.create(:category, user: FactoryBot.create(:user)) }

      it "responds with page not found" do
        delete(category_path(subject))

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when system's category" do
      subject { FactoryBot.create(:category) }

      it "responds with page not found" do
        delete(category_path(subject))

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
