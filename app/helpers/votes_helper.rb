# encoding: utf-8
module VotesHelper
  def  vote_up_path(votable)
    { controller: 'votes', action: 'create_vote',
      votable_id: votable.id, votable_type: votable.class, rating: 1 }
  end

  def vote_down_path(votable)
    { controller: 'votes', action: 'create_vote',
      votable_id: votable.id, votable_type: votable.class, rating: -1 }
  end
end
