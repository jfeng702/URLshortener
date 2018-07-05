class ShortenedUrl < ApplicationRecord
  validates :submitter_id, presence: true
  validates :short_url, uniqueness: true, presence: true
  validates :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: :User


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
