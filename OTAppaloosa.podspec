Pod::Spec.new do |s|
  s.name         = "OTAppaloosa"
  s.version      = "0.1.0"
  s.summary      = "Appaloosa SDK for iOS"
  s.homepage     = "http://www.appaloosa-store.com/"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Remy Virin" => "rvirin@octo.com", "Abdou Benhamouche" => "abenhamouche@octo.com" }
  s.source       = { :git => "https://github.com/octo-online/appaloosa-ios-sdk.git", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.source_files = 'OTAppaloosa'
  s.requires_arc = true
  
  s.dependency     'JSONKit', '~> 1.4'
end

