# frozen_string_literal: true

# Base for maintenance-queue jobs that should not retry (legacy Sidekiq retry: false).
class MaintenanceJob < ApplicationJob
  queue_as :maintenance

  discard_on StandardError do |job, error|
    Rails.logger.error "#{job.class.name} failed: #{error.message}"
  end
end
