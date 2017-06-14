Pod::Spec.new do |s|
  s.name         = "OTAppaloosa"
  s.version      = "0.6.2"
  s.summary      = "Appaloosa SDK for iOS."
  s.homepage     = "http://www.appaloosa-store.com/"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Robin Sfez" => "rsfez@octo.com", "Christophe Valentin" => "lv.beleck@gmail.com" }
  s.source       = { :git => "https://github.com/appaloosa-store/appaloosa-ios-sdk.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = "OTAppaloosa/**/*.{h,m}"
  s.resources    = "OTAppaloosa/**/*.{png,xib,strings}"
  s.frameworks   = 'QuartzCore', 'MessageUI', 'AdSupport'
  s.requires_arc = true
end
