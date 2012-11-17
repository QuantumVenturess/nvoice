class User < ActiveRecord::Base

	extend FriendlyId
	friendly_id :name, use: :slugged

	attr_accessor :password
	attr_accessible :name,
				  	:email,
				  	:password,
				  	:password_confirmation,
				  	:address,
				  	:city,
				  	:state,
				  	:zip,
				  	:phone

	has_many :bills, foreign_key: :user_id, class_name: 'Invoice'
	has_many :invoices, foreign_key: :client_id
	has_many :items

	# Name
	validate :name_validation	
	def name_validation
		if name.blank?
			errors.add(:name, "cannot be blank")
		elsif name.length < 1
			errors.add(:name, "is too short (minimum is 1 character")
		end
	end
	validates_uniqueness_of :name, case_sensitive: false, 
							message: 'is already taken'

	# Email
	validate :email_validation	
	def email_validation
		if email.blank?
			errors.add(:email, "cannot be blank")
		elsif email.match(
			/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i).nil?
			errors.add(:email, "is not in a valid format (e.g. jane_doe@gmail.com)")
		end
	end
	validates_uniqueness_of :email, case_sensitive: false, 
							message: "is already registered"

	# Password
	validates :password, confirmation: true
	validates :password, length: { within: 2..40 }, on: :create

	before_save :encrypt_password

	def phone_number
		if self.phone.nil?
			''
		else
			area_code = self.phone.to_s.split('')[0..2].join('')
			first_numbers = self.phone.to_s.split('')[3..5].join('')
			last_numbers = self.phone.to_s.split('')[6..9].join('')
			"#{area_code}.#{first_numbers}.#{last_numbers}"
		end
	end

	def paid
		self.invoices.where('paid = ?', true).size
	end

	def invoice_total
		self.invoices.map { |i| i.total }.sum
	end

	def invoice_due
		self.invoices.where(
			'paid = ?', false).map { |i| i.total }.sum
	end

	def self.search(search)
		if search
			where("name ILIKE ?", "%#{search}%")
		else
			scoped
		end
	end

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end

	private

		def encrypt_password
			unless password.blank?
				self.salt = make_salt unless has_password?(password)
				self.encrypted_password = encrypt(self.password)
			end
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end