# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string           not null
#  short_url    :string
#  submitter_id :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true
  validates :submitter_id, presence: true

  belongs_to :submitter,
    class_name: :User,
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: :Visit,
    foreign_key: :url_id,
    primary_key: :id

  has_many :visitors,
    through: :visits,
    source: :user

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      long_url: long_url,
      submitter_id: user.id,
      short_url: self.random_code
    )
  end

  def self.random_code
    potential_code = SecureRandom.urlsafe_base64

    while ShortenedUrl.exists?(short_url: potential_code)
      potential_code = SecureRandom.urlsafe_base64
    end

    potential_code
  end

end
