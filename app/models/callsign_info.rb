class CallsignInfo < ActiveRecord::Base
    validates :remote_user_id, presence: true, uniqueness: true
end
