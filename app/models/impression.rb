# frozen_string_literal: true

class Impression < ActiveRecord::Base
  belongs_to :impressionable, polymorphic: true
  belongs_to :user, optional: true

  # Scopes for analytics
  scope :recent, ->(duration = 1.month) { where("created_at > ?", duration.ago) }
  scope :for_resource, ->(type, id) { where(impressionable_type: type, impressionable_id: id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_ip, ->(ip) { where(ip_address: ip) }

  # Validations
  validates :impressionable_type, :impressionable_id, presence: true

  # Class methods for analytics
  def self.unique_views_for(resource)
    where(
      impressionable_type: resource.class.name,
      impressionable_id: resource.id
    ).select(:ip_address, :user_id, :session_hash)
     .distinct
     .count
  end

  def self.views_in_period(resource, duration = 1.month)
    for_resource(resource.class.name, resource.id)
      .recent(duration)
      .count
  end
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
#  params              :text
#
# Indexes
#
#  controlleraction_ip_index          (controller_name,action_name,ip_address)
#  controlleraction_request_index     (controller_name,action_name,request_hash)
#  controlleraction_session_index     (controller_name,action_name,session_hash)
#  impressionable_type_message_index  (impressionable_type,message,impressionable_id)
#  index_impressions_on_user_id       (user_id)
#  poly_ip_index                      (impressionable_type,impressionable_id,ip_address)
#  poly_params_request_index          (impressionable_type,impressionable_id,params)
#  poly_request_index                 (impressionable_type,impressionable_id,request_hash)
#  poly_session_index                 (impressionable_type,impressionable_id,session_hash)
#
