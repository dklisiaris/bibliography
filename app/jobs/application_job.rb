# frozen_string_literal: true

# :nodoc
class ApplicationJob < ActiveJob::Base
  retry_on ActiveRecord::Deadlocked
  discard_on ActiveJob::DeserializationError
end
