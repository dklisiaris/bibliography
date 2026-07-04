# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, ".from_omniauth", :omniauth, type: :model do
  let(:auth) do
    mock_omniauth_auth(
      provider: :facebook,
      uid: "fb-uid-1",
      email: "from-omniauth@example.com",
      name: "OAuth Name"
    )
  end

  it "creates a user with provider and uid" do
    user = described_class.from_omniauth(auth)

    expect(user).to be_persisted
    expect(user.provider).to eq("facebook")
    expect(user.uid).to eq("fb-uid-1")
    expect(user.email).to eq("from-omniauth@example.com")
  end

  it "returns the existing user for the same provider and uid" do
    existing = create(:user, provider: "facebook", uid: "fb-uid-1", email: "from-omniauth@example.com")

    expect {
      user = described_class.from_omniauth(auth)
      expect(user.id).to eq(existing.id)
    }.not_to change(described_class, :count)
  end

  it "populates profile name from auth info when blank" do
    user = described_class.from_omniauth(auth)

    expect(user.profile.name).to eq("OAuth Name")
  end
end
