require "rails_helper"

RSpec.describe Api::V1/UserWorkExperiencesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/v1/user_work_experiences").to route_to("api/v1/user_work_experiences#index")
    end

    it "routes to #show" do
      expect(get: "/v1/user_work_experiences/1").to route_to("api/v1/user_work_experiences#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/v1/user_work_experiences").to route_to("api/v1/user_work_experiences#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/v1/user_work_experiences/1").to route_to("api/v1/user_work_experiences#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/v1/user_work_experiences/1").to route_to("api/v1/user_work_experiences#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/v1/user_work_experiences/1").to route_to("api/v1/user_work_experiences#destroy", id: "1")
    end
  end
end
