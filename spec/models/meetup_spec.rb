require_relative "../../app/models/meetup.rb"

RSpec.describe Meetup do
  let(:meetup) { Meetup.new(name: "Bronx Hackers", description: "Come work on code or help others.", location: "Bronx, NY") }

  describe "#initialization" do
    it "returns a string of the meetup name" do
      expect(meetup.name).to eq("Bronx Hackers")
    end
    it "returns a string of the meetup description" do
      expect(meetup.description).to eq("Come work on code or help others.")
    end
    it "returns a string of the meetup location" do
      expect(meetup.location).to eq("Bronx, NY")
    end
  end
end
