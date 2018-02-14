class Vote < ApplicationRecord
  belongs_to :voter
  belongs_to :song
  attr_accessor :score
  def score
    self[:score]
  end
end
