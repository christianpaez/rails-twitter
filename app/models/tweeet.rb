class Tweeet < ApplicationRecord
    validates :tweeet, presence: true, allow_blank: false
    belongs_to :user
end
