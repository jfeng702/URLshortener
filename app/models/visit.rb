# == Schema Information
#
# Table name: visits
#
#  id           :bigint(8)        not null, primary key
#  visitor_id   :integer          not null
#  short_url_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Visit < ApplicationRecord
  validates :visitor, presence: true
  validates :short_url, presence: true

  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: :User

  belongs_to :short_url,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :ShortenedUrl

  def self.record_visit!(user, short_url)
    Visit.create!(
      visitor_id: user.id,
      short_url_id: short_url.id
    )
  end
end
