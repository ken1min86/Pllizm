class TreePath < ApplicationRecord
  belongs_to :ancestor_post,   class_name: 'Post', foreign_key: 'ancestor'
  belongs_to :descendant_post, class_name: 'Post', foreign_key: 'descendant'

  validates :ancestor,   presence: true
  validates :descendant, presence: true, uniqueness:   { scope: :ancestor }
  validates :depth,      presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
