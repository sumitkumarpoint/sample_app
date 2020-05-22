class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,:confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  has_many :profile_viewers
  has_many :posts
  has_many :post_viewers,through: :posts
  has_many :group_memberships
  has_many :user_groups, through: :memberships
  after_create :create_user_profile
  extend FriendlyId
  friendly_id :username, use: :slugged
  def normalize_friendly_id(string)
    super[0..150]
  end
  has_one :user_profile


  # def is_confirmation_period_expired?
  #   self.confirmation_period_expired? # self is optional
  # end

  def create_user_profile
    UserProfile.create(:user_id=>self.id)
  end

  def self.from_omniauth(auth)
    # auth={provider:"",uid:"",info:{name:"",email:""}}
    username = auth['info']['name'].match(/\s/) ? auth['info']['name'].rpartition(' ').first.downcase+"-"+auth['info']['name'].rpartition(' ').last.downcase :	auth['info']['name'].downcase
    fbuser = User.where('username LIKE ?', "%#{username}%").count
    if(fbuser!=0)
      fbusername = username+'-'+(fbuser+1).to_s
    else
      fbusername= username
    end

    if auth['provider'] == 'fb'
      email = auth['uid']+'@facebook.com'
    elsif auth['provider'] == 'twitter'
      email = auth['uid']+'@twitter.com'
    else
      email = auth['uid']+'@gmail.com'
    end

    auth_email =  auth['info']['email'].present? ? auth['info']['email'] : email

    if self.where(email: auth_email).exists?
      return_user = self.where(email: auth_email).first
      return_user.provider = auth['provider']
      return_user.uid = auth['provider']
      return_user
    else
      # where(email: auth_email).first_or_create do |user|
        where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
        if(auth['info']['email'].present?)
          user.email = auth['info']['email']
        else
          user.email = email
        end
        user.password = Devise.friendly_token[0,20]
        user.username = fbusername
        user.confirmed_at = Date.today
        #abort(user.inspect)

        user.skip_confirmation! #this is added to skip email confirmation when user register using facebook, as the email id must have already confirmed by Facebook
        #user.image = auth.info.image #This is used to fetch profile image from facebook, we will add this later
      end
    end
  end

end
