# frozen_string_literal: true

module SubscriptionsHelper
  def subscribe_path(question)
    { controller: "subscriptions", action: "create",
      question_id: question.id }
  end

  def unsubscribe_path(question)
    { controller: "subscriptions", action: "destroy",
      question_id: question.id }
  end
end
