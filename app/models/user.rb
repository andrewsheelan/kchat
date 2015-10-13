class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :create_md5

  CHANNEL_PREFIX = 'presence-'

  def create_md5
    self.md5 = Digest::MD5.hexdigest(self.email)
  end

  def as_json(options={})
    {
      id: id,
      email: email,
      img_src: "//www.gravatar.com/avatar/#{md5}?d=wavatar",
      channel: channel,
      online: Pusher.get("/channels/#{channel}")[:occupied]
    }
  end

  def channel
    "#{CHANNEL_PREFIX}#{id}"
  end

  def self.all_sorted
    json_hash = all.as_json
    json_hash.sort_by{ |hash| hash[:online].to_s }.reverse
  end
end
