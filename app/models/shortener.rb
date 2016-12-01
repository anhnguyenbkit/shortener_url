class Shortener < ApplicationRecord

	validates :long_url, presence: true, allow_blank: false
	has_attached_file :snapshot, default_url: "/images/:style/missing.png"
	validates_attachment :snapshot, :presence => true, allow_blank: true,
    :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] },
    :size => { :in => 0..5000.kilobytes }

	before_create :set_expiration_date

	def set_expiration_date
		self.expiration = Time.now + 1.hours
	end

	def self.del_expiration_record
		Shortener.where("expiration < ?", Time.now).destroy_all
	end
end
