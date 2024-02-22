class User < ApplicationRecord
    has_secure_password

    validate  :email, presence: true, uniqueness: true
    validates :password presesnce: true
    validates :name, presence: true
end
