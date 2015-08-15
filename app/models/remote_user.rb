class RemoteUser < ActiveRecord::Base
    validates :callsign, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true

    scope :like, -> (q) { where("UPPER(callsign) LIKE UPPER('%#{q}%')") }
    scope :with_info, -> { joins(:callsign_info).where("callsign_infos.id IS NOT NULL") }

    has_many :remote_sessions
    has_one :callsign_info
end
