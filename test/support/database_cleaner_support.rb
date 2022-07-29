# frozen_string_literal: true

module DatabaseCleanerSupport
  def before_setup
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end
end
