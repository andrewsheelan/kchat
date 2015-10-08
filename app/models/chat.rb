class Chat < ActiveRecord::Base
  belongs_to :typed_by, foreign_key: :user_id, class_name: 'User'
  serialize :conversation, Array

  def as_json(options={})
    super only: [:id, :message, :created_at, :conversation], include: {
      typed_by: {:only => [:id, :email]}
    }, methods: :created_info
  end
  def created_info
    created_at.to_f * 1000
  end
end
