require 'nine_astronauts/caching_mailer'

ActionMailer::Base.class_eval do
  include NineAstronauts::CachingMailer
end
