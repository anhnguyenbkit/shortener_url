require "rails_helper"

RSpec.describe ShortenersController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the posts into @shorteners" do
      shortener1, shortener2 = Shortener.create(:long_url => "abc"), Shortener.create(:long_url => "def")
      get :index

      expect(assigns(:shorteners)).to match_array([shortener1, shortener2])
    end
  end
end