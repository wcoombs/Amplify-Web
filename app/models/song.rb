class Song < ApplicationRecord
  has_many :votes
  belongs_to :room
  attr_accessor :vote_count

  def vote_count=(val)
    @vote_count = val
  end


  def vote_count
    @vote_count = 0
    votes.each do |v|
      @vote_count += v.score
    end
    @vote_count
  end
end
