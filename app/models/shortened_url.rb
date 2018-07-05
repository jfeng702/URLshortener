# == Schema Information
#
# Table name: shortened_urls
#
#  id           :bigint(8)        not null, primary key
#  short_url    :string           not null
#  long_url     :string           not null
#  submitter_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :submitter_id, presence: true
  validates :short_url, uniqueness: true, presence: true
  validates :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :visitor

  def num_clicks
    visits.count
  end

  def num_uniques
    visits.select(:visitor_id).distinct.count
  end

  def num_recent_uniques
    visits
      .select(:visitor_id)
      .where('created_at > ?', 10.minutes.ago)
      .distinct
      .count
  end

  def self.random_code
    random_code = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(:short_url => random_code)
      random_code = SecureRandom.urlsafe_base64
    end
    random_code
  end

  def self.create_for_user_and_long_url(user, long_url)
     ShortenedUrl.create!(
       submitter_id: user.id,
       long_url: long_url,
       short_url: ShortenedUrl.random_code
     )
  end
end
