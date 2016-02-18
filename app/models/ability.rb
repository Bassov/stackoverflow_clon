class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote]
    can :update, [Question, Answer], user: user
    can :destroy, [Answer, Question], user: user

    can :make_best, Answer, question: { user: user }
    can :destroy, Attachment, attachable: { user: user }
    cannot :create, Vote, votable: { user: user }
  end
end
