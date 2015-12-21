module VotesHelper
  def  vote_up_path(votable)
    {controller: "votes", action: "vote_up",
     votable_id: votable.id, votable_type: votable.class}
  end

  def  vote_down_path(votable)
    {controller: "votes", action: "vote",
     votable_id: votable.id, votable_type: votable.class}
  end

  def  unvote_path(votable)
    {controller: "votes", action: "unvote",
     votable_id: votable.id, votable_type: votable.class}
  end
end