# frozen_string_literal: true

json.id @votable.id
json.rating @votable.votes.rating
json.klass @votable.class.to_s.underscore
