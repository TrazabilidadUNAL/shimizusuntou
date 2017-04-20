Apipie.configure do |config|
  config.app_name                = "Shimizusuntou"
  config.doc_base_url            = "/apidoc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
