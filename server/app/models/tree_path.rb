class TreePath < ApplicationRecord
  belongs_to :ancestor_post, class_name: 'Post', :foreign_key => 'ancestor'
  belongs_to :descendant_post, class_name: 'Post', :foreign_key => 'descendant'

  validates :ancestor,   presence: true
  validates :descendant, presence: true, uniqueness: { scope: :ancestor }
  validates :depth,      presence: true, length: { minimum: 0 }
end
