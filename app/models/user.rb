class User < ApplicationRecord
    has_secure_password
    enum role: [:admin, :user]

    validates  :email, presence: true, uniqueness: true
    validates :password, presence: true
    validates :name, presence: true
    validates :role, presence: true
end
