class Impression < ActiveRecord::Base
  belongs_to :impressionable, polymorphic: true

end

# == Schema Information
#
# Table name: impressions
#
#  id                  :integer          not null, primary key
#  impressionable_type :string
#  impressionable_id   :integer
#  user_id             :integer
#  controller_name     :string
#  action_name         :string
#  view_name           :string
#  request_hash        :string
#  ip_address          :string
#  session_hash        :string
#  message             :text
#  referrer            :text
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  controlleraction_ip_index          (controller_name,action_name,ip_address)
#  controlleraction_request_index     (controller_name,action_name,request_hash)
#  controlleraction_session_index     (controller_name,action_name,session_hash)
#  impressionable_type_message_index  (impressionable_type,message,impressionable_id)
#  index_impressions_on_user_id       (user_id)
#  poly_ip_index                      (impressionable_type,impressionable_id,ip_address)
#  poly_request_index                 (impressionable_type,impressionable_id,request_hash)
#  poly_session_index                 (impressionable_type,impressionable_id,session_hash)
#
