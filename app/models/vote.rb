class Vote < ApplicationRecord
  belongs_to :voter
  belongs_to :song

  def score
    self[:score]
  end
end
