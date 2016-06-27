Pod::Spec.new do |s|
  s.name         = "OTAppaloosa"
  s.version      = "0.6.0"
  s.summary      = "Appaloosa SDK for iOS."
  s.homepage     = "http://www.appaloosa-store.com/"
  s.license      = 'Apache License, Version 2.0'
s.author       = { "Remy Virin" => "rvirin@octo.com", "Abdou Benhamouche" => "abenhamouche@octo.com", "Maxence Walbrou" => "mwalbrou@gmail.com", "Mahmoud Reda" => "mmm@octo.com", "Cédric Pointel" => "cpointel@octo.com", "Robin Sfez" => "rsfez@octo.com", "Christophe Valentin" => "lv.beleck@gmail.com" }
  s.source       = { :git => "https://github.com/appaloosa-store/appaloosa-ios-sdk", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.source_files = "OTAppaloosa/**/*.{h,m}"
  s.resources    = "OTAppaloosa/**/*.{png,xib,strings}"
  s.frameworks   = 'QuartzCore', 'MessageUI', 'AdSupport'
  s.requires_arc = true

  s.dependency     'TPKeyboardAvoiding', '~> 1.1'
  s.dependency     'UIDeviceAddition', '~> 1.0'
  s.dependency     'Reachability', '~> 3.2'
  s.dependency     'Base64', '~> 1.0.1'
  s.dependency     'SFHFKeychainUtils', '~> 0.0'
end
