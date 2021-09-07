require 'rails_helper'

RSpec.describe "Batch::Cron::RefractBatch", type: :request do
  # ****************************************************************************************
  #   it内でテストしている内容は以下の理由からuserに限っており、followerに関してはテストしない。
  #   -userとfollowerの両方の観点でテストすると、テスト内容が分かりにくくなるため
  #   -userに観点を絞ってテストすることで、自動的にfollowerに関しても正常に動作することがテストできるため
  # ****************************************************************************************
  context "when 2 user exists
  who don't have any refracts
  and have 2 followers
  and have refract candidate" do
    before do
      travel_to Time.zone.local(2021, 8, 27) do
        create(:icon)

        @user1 = create(:user)
        @user2 = create(:user)

        @follower_of_user1 = create_follow_user(@user1)
        create_follow_user(@user1)
        @follower_of_user2 = create_follow_user(@user2)
        create_follow_user(@user2)

        @post_of_user1 = create(:post, user_id: @user1.id)
        @post_of_user2 = create(:post, user_id: @user2.id)
        create_reply_to_prams_post(@follower_of_user1, @post_of_user1)
        create_reply_to_prams_post(@follower_of_user2, @post_of_user2)
      end
    end

    it 'creates not deleted CurrentUserRefracts' do
      travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
        expect  do
          Batch::Cron::RefractBatch.weekly_set_refract
        end.to change { CurrentUserRefract.without_deleted.all.length }.from(0).to(2)
        expect(CurrentUserRefract.without_deleted.find_by(user_id: @user1.id).present?).to eq(true)
        expect(CurrentUserRefract.without_deleted.find_by(user_id: @user2.id).present?).to eq(true)
      end
    end
  end

  context "when 1 user exists
  who doesn't have any refracts
  and has 2 followers
  and has refract candidate" do
    before do
      travel_to Time.zone.local(2021, 8, 27) do
        create(:icon)

        @user = create(:user)

        @follower_of_user = create_follow_user(@user)
        create_follow_user(@user)

        @post_of_user = create(:post, user_id: @user.id)
        create_reply_to_prams_post(@follower_of_user, @post_of_user)
      end
    end

    it 'creates not deleted CurrentUserRefracts' do
      travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
        expect  do
          Batch::Cron::RefractBatch.weekly_set_refract
        end.to change { CurrentUserRefract.without_deleted.all.length }.from(0).to(1)
        expect(CurrentUserRefract.without_deleted.find_by(user_id: @user.id).present?).to eq(true)
      end
    end
  end

  context "when 1 user exists
  who has not-performed refract
  and has 2 followers
  and has refract candidate" do
    before do
      travel_to Time.zone.local(2021, 8, 27) do
        create(:icon)

        @user = create(:user)

        @follower_of_user = create_follow_user(@user)
        create_follow_user(@user)

        @post1_of_user = create(:post, user_id: @user.id)
        create_reply_to_prams_post(@follower_of_user, @post1_of_user)
      end

      travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
        Batch::Cron::RefractBatch.weekly_set_refract
      end

      travel_to Time.zone.local(2021, 8, 29) do
        @post2_of_user = create(:post, user_id: @user.id)
        create_reply_to_prams_post(@follower_of_user, @post2_of_user)
      end
    end

    it 'deletes not-performed refract last week
    and not deleted CurrentUserRefracts' do
      travel_to Time.zone.local(2021, 9, 4, 5, 30, 0o0) do
        not_performed_refract_last_week = CurrentUserRefract.without_deleted.find_by(user_id: @user, performed_refract: false)
        expect(not_performed_refract_last_week.deleted?).to eq(false)

        Batch::Cron::RefractBatch.weekly_set_refract
        expect(not_performed_refract_last_week.reload.deleted?).to eq(true)
        expect(CurrentUserRefract.without_deleted.find_by(user_id: @user.id).present?).to eq(true)
      end
    end
  end

  context "when 1 user exists
  who doesn't have any refracts
  and has 1 follower
  and has refract candidate" do
    before do
      travel_to Time.zone.local(2021, 8, 27) do
        create(:icon)
        @user = create(:user)
        @follower_of_user = create_follow_user(@user)
        @post_of_user = create(:post, user_id: @user.id)
        create_reply_to_prams_post(@follower_of_user, @post_of_user)
      end
    end

    it 'creates deleted CurrentUserRefract' do
      travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
        expect  do
          Batch::Cron::RefractBatch.weekly_set_refract
        end.to change { CurrentUserRefract.with_deleted.where(user_id: @user.id).length }.from(0).to(1)
      end
    end
  end

  context "when 1 user exists
  who doesn't have any refracts
  and has 2 followers
  and doesn't have refract candidate" do
    before do
      travel_to Time.zone.local(2021, 8, 27) do
        create(:icon)
        @user = create(:user)
        create_follow_user(@user)
        create_follow_user(@user)
      end
    end

    it 'creates deleted CurrentUserRefract' do
      travel_to Time.zone.local(2021, 8, 28, 5, 30, 0o0) do
        expect  do
          Batch::Cron::RefractBatch.weekly_set_refract
        end.to change { CurrentUserRefract.with_deleted.where(user_id: @user.id).length }.from(0).to(1)
      end
    end
  end

  context "when no user exists" do
    it "doesn't create CurrentUserRefract" do
      expect(User.all.length).to eq(0)
      Batch::Cron::RefractBatch.weekly_set_refract
      expect(CurrentUserRefract.with_deleted.all.length).to eq(0)
    end
  end
end
