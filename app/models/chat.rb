class Chat < ActiveRecord::Base
  belongs_to :user
  def as_json(options={})
    super only: [:id, :message, :created_at], include: {
      user: {:only => :email}
    }, methods: :created_info
  end
  def created_info
    created_at.to_f * 1000
  end
end
