class Shortener < ApplicationRecord
	validates :long_url, presence: true, allow_blank: false

	before_create :set_expiration_date

	def set_expiration_date
		self.expiration = Time.now + 1.hours
	end

	def self.del_expiration_record
		Shortener.where("expiration < ?", Time.now).destroy_all
	end
end
