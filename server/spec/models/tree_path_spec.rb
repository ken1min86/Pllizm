require 'rails_helper'

RSpec.describe TreePath, type: :model do
  before do
    FactoryBot.create(:icon)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:ancestor_post) { FactoryBot.create(:post, user_id: user.id) }
  let(:descendant_post) { FactoryBot.create(:post, user_id: user.id) }

  it 'is valid when ancestor and descendant are related to post and depth in over 0' do
    tree_path = TreePath.new(
      ancestor: ancestor_post.id,
      descendant: descendant_post.id,
      depth: 0
    )
    expect(tree_path).to be_valid
  end

  it "is invalid when combination of ancestor and descendant isn't unique " do
    TreePath.create(
      ancestor: ancestor_post.id,
      descendant: descendant_post.id,
      depth: 0
    )
    tree_path = TreePath.new(
      ancestor: ancestor_post.id,
      descendant: descendant_post.id,
      depth: 0
    )
    tree_path.valid?
    expect(tree_path.errors[:descendant]).to include('has already been taken')
  end

  it "is invalid when ancestor isn't related to post" do
    not_related_to_post_id = get_non_existent_post_id
    tree_path = TreePath.new(
      ancestor: not_related_to_post_id,
      descendant: descendant_post.id,
      depth: 0
    )
    expect(tree_path).to be_invalid
  end

  it "is invalid when descendant isn't related to post" do
    not_related_to_post_id = get_non_existent_post_id
    tree_path = TreePath.new(
      ancestor: ancestor_post.id,
      descendant: not_related_to_post_id,
      depth: 0
    )
    expect(tree_path).to be_invalid
  end

  it 'is invalid when depth is -1' do
    tree_path = TreePath.new(
      ancestor: ancestor_post.id,
      descendant: descendant_post.id,
      depth: -1
    )
    tree_path.valid?
    expect(tree_path.errors[:depth]).to include('must be greater than or equal to 0')
  end

  it 'is invalid without ancestor' do
    tree_path = TreePath.new(
      descendant: descendant_post.id,
      depth: 0
    )
    tree_path.valid?
    expect(tree_path.errors[:ancestor]).to include("can't be blank")
  end

  it 'is invalid without descendant' do
    tree_path = TreePath.new(
      ancestor: ancestor_post.id,
      depth: 0
    )
    tree_path.valid?
    expect(tree_path.errors[:descendant]).to include("can't be blank")
  end

  it 'is invalid without depth' do
    tree_path = TreePath.new(
      ancestor: ancestor_post.id,
      descendant: descendant_post.id,
    )
    tree_path.valid?
    expect(tree_path.errors[:depth]).to include("can't be blank")
  end

  def get_non_existent_post_id
    non_existent_post_id = SecureRandom.alphanumeric(20)
    while Post.find_by(id: non_existent_post_id)
      non_existent_post_id = SecureRandom.alphanumeric(20)
    end
    non_existent_post_id
  end
end
