# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class User < ApplicationRecord
  include CaseSensitivity, StripAttribute, DowncaseAttribute

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :validatable, :timeoutable, :trackable

  strip_attributes! :email
  downcase_attributes! :email

  attr_accessor :password_required

  THROTTLE_RESET_PERIOD = 2
  DEFAULT_PASSWORD_EXPIRY_PERIOD = 1.months.from_now

  attribute :is_active, default: false
  attribute :is_banned, default: false
  attribute :password_expires_at, default: DEFAULT_PASSWORD_EXPIRY_PERIOD
  attribute :password_automatically_set, default: false

  validates :first_name, :last_name,
            presence: true,
            length: {maximum: 55},
            reduce: true
  validates :password,
            presence: true,
            password: true,
            length: {in: 8..20},
            confirmation: {case_sensitive: false},
            reduce: true,
            if: :password_required?
  validates :password_confirmation,
            presence: true,
            reduce: true,
            if: :password_required?

  has_one :address, as: :addressable, dependent: :destroy
  has_many :taxes, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :quotes, foreign_key: :client_id, dependent: :nullify
  has_many :created_quotes, class_name: "::Quote", dependent: :destroy
  has_many :invoices, foreign_key: :client_id, dependent: :nullify
  has_many :created_invoices, class_name: "::Invoice", dependent: :destroy

  has_many :request_logs, dependent: :nullify

  belongs_to :role

  delegate :name, to: :role, prefix: true

  scope :with_role, -> (role_name) do
    role_table = ::Role.arel_table
    user_table = ::User.arel_table
    join = user_table.join(role_table)
     .on(user_table[:role_id].eq(role_table[:id]))
     .join_sources
   joins(join).where(role_table[:name].eq(role_name))
  end
  scope :admins, -> { with_role("admin") }
  scope :clients, -> { with_role("client") }

  accepts_nested_attributes_for :address, update_only: true

  class << self
    def with_email(email)
      iwhere(email: email).first
    end

    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      email = conditions.delete(:email)
      where(conditions).with_email(email)
    end

    def send_reset_password_instructions(attributes = {})
      recoverable = find_or_initialize_recoverable_with_errors(reset_password_keys, attributes, :not_found)
      recoverable.send_reset_password_instructions if recoverable.persisted?
      recoverable
    end

    def find_or_initialize_recoverable_with_errors(required_attributes, attributes, error = :invalid)
      attributes = attributes.slice(*required_attributes)
      email = attributes[:email]
      record = with_email(email)

      unless record
        record = new
        required_attributes.each do |key|
          value = attributes[key]
          record.send("#{key}=", value)
          if value.present?
            record.errors.add(key, error)
          else
            record.errors.add(key, :blank)
          end
        end
      end

      record.email = email
      record
    end

    def select_options
      all.collect { |user| [user.full_name, user.id] }
    end
  end

  def full_name
    "#{try(:first_name)} #{try(:last_name)}"
  end

  def recently_sent_password_reset_instructions?
    reset_password_sent_at.present? && reset_password_sent_at >= THROTTLE_RESET_PERIOD.minute.ago
  end

  def active_for_authentication?
    super && is_active?
  end

  def admin?
    self.has_role?("admin")
  end

  def client?
    self.has_role?("client")
  end

  def has_role?(role)
    role.eql?(self.role_name)
  end

  def has_any_role?(*roles)
    roles.include?(self.role_name)
  end

  def has_no_role?(role)
    !has_role?(role)
  end

  def has_no_roles?(*roles)
    !has_any_role?(*roles)
  end

  def address
    super.presence || build_address
  end

  private

  def password_present?
    password.present?
  end

  def password_required?
    !!password_required
  end
end
