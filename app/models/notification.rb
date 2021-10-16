class Notification < ApplicationRecord

  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :post_comment, optional: true

  # visitor_id : 通知を送ったユーザーのid  visited_id : 通知を送られたユーザーのid
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end