# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vk]

  has_many :answers
  has_many :questions
  has_many :votes
  has_many :comments
  has_many :authorizations

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end

  def vote_for(votable, rating)
    vote = votes.new(votable: votable, rating: rating)
    vote.save
  end

  def unvote_for(votable)
    votes.where(votable: votable).delete_all
  end

  def voted_for?(votable)
    votes.where(votable: votable).any?
  end

  def self.find_for_oauth(auth)
    return if auth.nil? || auth.empty?
    return if auth.provider.nil? || auth.uid.nil?
    return if auth.provider.empty? || auth.uid.try(:empty?)

    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email] if auth.info
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]

      if email
        user = User.create!(email: email, password: password, password_confirmation: password)
      else
        user = User.create!(email: 'email@temporary.com', password: password, password_confirmation: password)
        email = "#{user.id}@stackoverflow_clon.com"
        user.email = email
        user.save
      end
    end

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
