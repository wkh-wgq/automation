class ApplicationMailbox < ActionMailbox::Base
  delegate :logger, to: :Rails
  # routing /something/i => :somewhere
  routing all: :support
end
