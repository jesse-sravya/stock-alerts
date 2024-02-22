class User < ApplicationRecord
    has_secure_password
    has_many :alerts
    enum role: [:admin, :user]

    VIEWABLE_ATTRIBUTES = [:id, :name, :email, :created_at, :updated_at]

    validates  :email, presence: true, uniqueness: true
    validates :password, presence: true
    validates :name, presence: true
    validates :role, presence: true
end
