Pod::Spec.new do |s|
  s.name         = "OTAppaloosa"
  s.version      = "0.3.4"
  s.summary      = "Appaloosa SDK for iOS."
  s.homepage     = "http://www.appaloosa-store.com/"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Remy Virin" => "rvirin@octo.com", "Abdou Benhamouche" => "abenhamouche@octo.com", "Maxence Walbrou" => "mwalbrou@gmail.com", "Mahmoud Reda" => "mmm@octo.com", "Cedric Pointel" => "cpointel@octo.com" }
  s.source       = { :git => "https://github.com/octo-online/appaloosa-ios-sdk.git", :branch => '
killswitch'}
  s.platform     = :ios, '5.0'
  s.source_files = "OTAppaloosa/**/*.{h,m}"
  s.resources    = "{OTAppaloosa/**/*.{png,xib}"
  s.frameworks   = 'QuartzCore', 'MessageUI'
  s.requires_arc = true

  s.dependency     'TPKeyboardAvoiding'
end
