require 'rails_helper'

RSpec.describe "V1::RefractsApi", type: :request do
  describe "GET /v1/posts/:refract_candidate_id/refracts - v1/refracts#perform_refract - Perform refract" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      let(:client_user)      { create(:user) }
      let(:client_user_post) { create(:post, user_id: client_user.id) }

      it "returns 401" do
        post v1_refract_performed_path(client_user_post.id)
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token and has performed CurrentUserRefract record" do
      before do
        create(:icon)
        CurrentUserRefract.create(user_id: client_user.id, performed_refract: true)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }
      let(:client_user_post)    { create(:post, user_id: client_user.id) }

      it 'returns 403' do
        expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1
        expect(client_user.current_user_refracts.where(performed_refract: false).length).to eq 0

        post v1_refract_performed_path(client_user_post.id), headers: client_user_headers
        expect(response).to         have_http_status(403)
        expect(response.message).to include('Forbidden')
        expect(JSON.parse(response.body)['errors']['title']).to include('リフラクト機能を使用できません')
      end
    end

    context "when client has token and has not performed CurrentUserRefract record" do
      context "params post doesn't relate to refract candidate" do
        before do
          create(:icon)
          CurrentUserRefract.create(user_id: client_user.id, performed_refract: false)
        end

        let(:client_user)          { create(:user) }
        let(:client_user_headers)  { client_user.create_new_auth_token }
        let(:non_existent_post_id) { get_non_existent_post_id }

        it ' returns 403' do
          post v1_refract_performed_path(non_existent_post_id), headers: client_user_headers
          expect(response).to         have_http_status(403)
          expect(response.message).to include('Forbidden')
          expect(JSON.parse(response.body)['errors']['title']).to include('リフラクト対象外の投稿です')
        end
      end

      context "params post relates to refract candidate of like" do
        before do
          travel_to Time.zone.local(2021, 8, 27) do
            create(:icon)

            @client_user         = create(:user)
            @client_user_headers = @client_user.create_new_auth_token

            @follower = create_mutual_follow_user(@client_user)
            create_mutual_follow_user(@client_user)

            @liked_post_of_follower = create(:post, user_id: @follower.id)
            post v1_post_likes_path(@liked_post_of_follower.id), headers: @client_user_headers
          end

          travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
            Batch::Cron::RefractBatch.weekly_set_refract
            @current_user_refract = CurrentUserRefract.find_by(user_id: @client_user, performed_refract: false)
          end
        end

        it 'returns 200 and creates CurrentUserRefract and FollowerRefract' do
          travel_to Time.zone.local(2021, 8, 28, 5, 31, 0o0) do
            expect do
              post v1_refract_performed_path(@liked_post_of_follower.id), headers: @client_user_headers
            end.to change(FollowerRefract.all, :count).by(1).
              and change(FollowerRefract.where(user_id: @follower.id), :count).from(0).to(1)

            expect(response).to         have_http_status(200)
            expect(response.message).to include('OK')

            expect(@current_user_refract.reload.performed_refract).to eq(true)
            expect(@current_user_refract.reload.post_id).to           eq(@liked_post_of_follower.id)
            expect(@current_user_refract.reload.category).to          eq('like')

            expect(FollowerRefract.where(
              user_id: @follower.id,
              follower_id: @client_user.id,
              post_id: @liked_post_of_follower.id,
              category: 'like'
            )).to exist
          end
        end
      end

      context "params post relates to refract candidate of reply
      and thread of params post includes 1 follower's post" do
        before do
          travel_to Time.zone.local(2021, 8, 27, 0, 0, 0) do
            create(:icon)

            @client_user         = create(:user)
            @client_user_headers = @client_user.create_new_auth_token

            @follower = create_mutual_follow_user(@client_user)
            create_mutual_follow_user(@client_user)

            @post_of_client_user = create(:post, user_id: @client_user.id)
          end

          travel_to Time.zone.local(2021, 8, 27, 0, 1, 0) do
            @reply_of_follwer = create_reply_to_prams_post(@follower, @post_of_client_user)
          end

          travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
            Batch::Cron::RefractBatch.weekly_set_refract
            @current_user_refract = CurrentUserRefract.find_by(user_id: @client_user, performed_refract: false)
          end
        end

        it 'returns 200 and creates CurrentUserRefract and FollowerRefract' do
          travel_to Time.zone.local(2021, 8, 28, 5, 31, 0o0) do
            expect do
              post v1_refract_performed_path(@reply_of_follwer.id), headers: @client_user_headers
            end.to change(FollowerRefract.all, :count).by(1).
              and change(FollowerRefract.where(user_id: @follower.id), :count).from(0).to(1)

            expect(response).to         have_http_status(200)
            expect(response.message).to include('OK')

            expect(@current_user_refract.reload.performed_refract).to eq(true)
            expect(@current_user_refract.reload.post_id).to           eq(@reply_of_follwer.id)
            expect(@current_user_refract.reload.category).to          eq('reply')

            expect(FollowerRefract.where(
              user_id: @follower.id,
              follower_id: @client_user.id,
              post_id: @reply_of_follwer.id,
              category: 'reply'
            )).to exist
          end
        end
      end

      context "params post relates to refract candidate of reply
      and thread of params post includes 2 follower's posts" do
        before do
          travel_to Time.zone.local(2021, 8, 27, 0, 0, 0) do
            create(:icon)

            @client_user         = create(:user)
            @client_user_headers = @client_user.create_new_auth_token

            @follower1 = create_mutual_follow_user(@client_user)
            @follower2 = create_mutual_follow_user(@client_user)

            @post_of_client_user = create(:post, user_id: @client_user.id)
          end

          travel_to Time.zone.local(2021, 8, 27, 0, 1, 0) do
            @reply_of_follwer1    = create_reply_to_prams_post(@follower1,   @post_of_client_user)
            @reply_of_client_user = create_reply_to_prams_post(@client_user, @reply_of_follwer1)
            @reply_of_follwer2    = create_reply_to_prams_post(@follower2,   @reply_of_client_user)
          end

          travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
            Batch::Cron::RefractBatch.weekly_set_refract
            @current_user_refract = CurrentUserRefract.find_by(user_id: @client_user, performed_refract: false)
          end
        end

        it 'returns 200 and creates CurrentUserRefract and FollowerRefracts' do
          travel_to Time.zone.local(2021, 8, 28, 5, 31, 0o0) do
            expect do
              post v1_refract_performed_path(@reply_of_follwer2.id), headers: @client_user_headers
            end.to change(FollowerRefract.all, :count).by(2).
              and change(FollowerRefract.where(user_id: @follower1.id), :count).from(0).to(1).
              and change(FollowerRefract.where(user_id: @follower2.id), :count).from(0).to(1)

            expect(response).to         have_http_status(200)
            expect(response.message).to include('OK')

            expect(@current_user_refract.reload.performed_refract).to eq(true)
            expect(@current_user_refract.reload.post_id).to           eq(@reply_of_follwer2.id)
            expect(@current_user_refract.reload.category).to          eq('reply')

            expect(FollowerRefract.where(
              user_id: @follower1.id,
              follower_id: @client_user.id,
              post_id: @reply_of_follwer2.id,
              category: 'reply'
            )).to exist

            expect(FollowerRefract.where(
              user_id: @follower2.id,
              follower_id: @client_user.id,
              post_id: @reply_of_follwer2.id,
              category: 'reply'
            )).to exist
          end
        end
      end

      context "params post relates to refract candidate of reply
      and thread of params post includes 1 follower's post and 1 not-follower's post" do
        before do
          travel_to Time.zone.local(2021, 8, 27, 0, 0, 0) do
            create(:icon)

            @client_user         = create(:user)
            @client_user_headers = @client_user.create_new_auth_token

            create_mutual_follow_user(@client_user)
            @follower     = create_mutual_follow_user(@client_user)
            @not_follower = create_mutual_follow_user(@follower)

            @post_of_client_user = create(:post, user_id: @client_user.id)
          end

          travel_to Time.zone.local(2021, 8, 27, 0, 1, 0) do
            @reply1_of_follwer = create_reply_to_prams_post(@follower, @post_of_client_user)
          end

          travel_to Time.zone.local(2021, 8, 27, 0, 2, 0) do
            @reply_of_not_follower = create_reply_to_prams_post(@not_follower, @reply1_of_follwer)
          end

          travel_to Time.zone.local(2021, 8, 27, 0, 3, 0) do
            @reply2_of_follower = create_reply_to_prams_post(@follower, @reply_of_not_follower)
          end

          travel_to Time.zone.local(2021, 8, 28, 5, 30, 0) do
            Batch::Cron::RefractBatch.weekly_set_refract
            @current_user_refract = CurrentUserRefract.find_by(user_id: @client_user, performed_refract: false)
          end
        end

        it 'returns 200 and creates CurrentUserRefract and FollowerRefracts' do
          travel_to Time.zone.local(2021, 8, 28, 5, 31, 0) do
            expect do
              post v1_refract_performed_path(@reply2_of_follower.id), headers: @client_user_headers
            end.to change(FollowerRefract.all, :count).by(1).
              and change(FollowerRefract.where(user_id: @follower.id), :count).from(0).to(1)

            expect(response).to         have_http_status(200)
            expect(response.message).to include('OK')

            expect(@current_user_refract.reload.performed_refract).to eq(true)
            expect(@current_user_refract.reload.post_id).to           eq(@reply2_of_follower.id)
            expect(@current_user_refract.reload.category).to          eq('reply')

            expect(FollowerRefract.where(
              user_id: @follower.id,
              follower_id: @client_user.id,
              post_id: @reply2_of_follower.id,
              category: 'reply'
            )).to exist
          end
        end
      end
    end
  end

  describe "GET /v1/refracts/skip - v1/refracts#skip - Skip refract" do
    context "when client doesn't have token" do
      before do
        create(:icon)
      end

      it "returns 401" do
        post v1_skip_path
        expect(response).to         have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context "when client has token and has performed CurrentUserRefract record" do
      before do
        create(:icon)
        CurrentUserRefract.create(user_id: client_user.id, performed_refract: true)
      end

      let(:client_user)         { create(:user) }
      let(:client_user_headers) { client_user.create_new_auth_token }

      it 'returns 403' do
        expect(client_user.current_user_refracts.where(performed_refract: true).length).to eq 1
        expect(client_user.current_user_refracts.where(performed_refract: false).length).to eq 0

        post v1_skip_path, headers: client_user_headers
        expect(response).to         have_http_status(403)
        expect(response.message).to include('Forbidden')
        expect(JSON.parse(response.body)['errors']['title']).to include('リフラクト機能を使用できません')
      end
    end

    context "when client has token and has not performed CurrentUserRefract record" do
      before do
        create(:icon)
      end

      let(:client_user)          { create(:user) }
      let(:client_user_headers)  { client_user.create_new_auth_token }
      let!(:client_user_refract) { CurrentUserRefract.create(user_id: client_user.id, performed_refract: false) }

      it 'returns 200 and update CurrentUserRefract to performed' do
        post v1_skip_path, headers: client_user_headers
        expect(response).to         have_http_status(200)
        expect(response.message).to include('OK')
        expect(client_user_refract.reload.performed_refract).to eq(true)
      end
    end
  end
end
