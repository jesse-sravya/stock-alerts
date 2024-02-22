class Alert < ApplicationRecord
    belongs_to :user
    STATUS_CREATED = "created"
    STATUS_DELETED = "deleted"
    STATUS_TRIGGERED = "triggered"

    validates :currency, presence: true
    validates :current_price, presence: true
    validates :target_price, presence: true
    validates :status, presence: true, inclusion: { in: [STATUS_CREATED, STATUS_DELETED, STATUS_TRIGGERED] }
end
