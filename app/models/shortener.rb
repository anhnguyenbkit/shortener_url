class Shortener < ApplicationRecord

	validates :long_url, presence: true, allow_blank: false

	has_attached_file :snapshot, default_url: "/images/:style/missing.png"

	validates_attachment :snapshot, allow_blank: true,
    :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] },
    :size => { :in => 0..5000.kilobytes }

	scope :active, -> { self.where('created_at >= ?', 1.hours.ago) }

	scope :inactive, -> { self.where('created_at < ?', 1.hours.ago) }

	before_create :generate_short_url

	# after_create :snapshot_url //because it very slow, so we optimize it and use later

	after_initialize :init

	def self.del_expiration_record
		Shortener.where("expiration < ?", Time.now).destroy_all
	end

	def snapshot_url
    kit   = IMGKit.new(self.long_url, quality: 5, width: 400, height: 500, zoom: 0.4)
    img   = kit.to_img(:png)
    file  = Tempfile.new(["template_#{self.id}", 'png'], 'tmp',
                         :encoding => 'ascii-8bit')
    file.write(img)
    file.flush
    self.snapshot = file
    file.unlink
  end

	private

	def init
		self.num_click ||= 0
	end

	def generate_short_url
		begin
			self.short_url = SecureRandom.hex(4)
		end while Shortener.active.exists?(short_url: self.short_url)
	end


end
