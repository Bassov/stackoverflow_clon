json.answer do
  json.id @answer.id
  json.body @answer.body
  json.rating @answer.votes.rating
  json.klass @answer.class.to_s
end

json.user_id current_user.id