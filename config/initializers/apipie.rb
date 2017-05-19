Apipie.configure do |config|
  config.app_name = 'Shimizusuntou'
  config.doc_base_url = '/apidoc'
  config.validate = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.app_info['1.0'] = 'RoR Gretel Backend API Project.'
  config.copyright = '&copy; 2017 Gretel Team'
end
