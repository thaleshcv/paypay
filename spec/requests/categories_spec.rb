require "rails_helper"

RSpec.describe "Categories", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  before { sign_in(current_user) }

  describe "GET /new" do
    it "responds with success" do
      get new_category_path

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    def create_category
      post categories_path, params: {
        category: {
          name: Faker::Lorem.word
        }
      }
    end

    it "creates a new user's category" do
      expect { create_category }.to change { Category.where(user_id: current_user).count }.by(1)
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

      it "responds with success" do
        put(category_path(subject), params: {
          category: {
            name: "new category name"
          }
        })

        expect(response).to be_successful
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

      it "responds with success" do
        delete(category_path(subject))

        expect(response).to be_successful
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
