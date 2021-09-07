require 'rails_helper'

RSpec.describe "V1::CurrentUserRefractsApi", type: :request do
  describe "GET /v1/statuses/refracts - v1/current_user_refracts#show_statuses - Get performance status of refract" do
    context "when client doesn't have token" do
      it "returns 401" do
        get v1_refracts_statuses_path
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token" do
      before do
        create(:icon)
      end

      let(:client_user) { create(:user) }
      let(:headers)     { client_user.create_new_auth_token }
      let(:follower)    { create(:user) }
      let(:post)        { create(:post, user_id: client_user.id) }

      context 'when client has no CurrentUserRefracts' do
        it 'returns 200 and true' do
          expect(CurrentUserRefract.where(user_id: client_user.id)).not_to exist

          get v1_refracts_statuses_path, headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:performed_refract]).to eq(true)
        end
      end

      context "when client has not performed CurrentUserRefract" do
        before do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: false,
            post_id: post.id,
            category: 'like'
          )
        end

        it 'returns 200 and false' do
          expect(CurrentUserRefract.where(user_id: client_user.id, performed_refract: false)).to exist

          get v1_refracts_statuses_path, headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:performed_refract]).to eq(false)
        end
      end

      context "when client doesn't have not performed CurrentUserRefract" do
        before do
          CurrentUserRefract.create(
            user_id: client_user.id,
            performed_refract: true,
            post_id: post.id,
            category: 'like'
          )
        end

        it 'returns 200 and true' do
          expect(CurrentUserRefract.where(user_id: client_user.id, performed_refract: false)).not_to exist

          get v1_refracts_statuses_path, headers: headers
          expect(response).to         have_http_status(200)
          expect(response.message).to include('OK')

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:performed_refract]).to eq(true)
        end
      end
    end
  end
end
