# frozen_string_literal: true

class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :password_digest
  validates :email, uniqueness: true, presence: true
  has_many :user_parties
  has_many :parties, through: :user_parties

  has_secure_password
end
