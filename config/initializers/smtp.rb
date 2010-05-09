ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'mpower.flinter.org',
  :authentication => :plain,
  :user_name => "sflinter@gmail.com",
  :password => "android!"
}
