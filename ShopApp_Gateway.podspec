Pod::Spec.new do |s|
  s.name         = "ShopApp_Gateway"
  s.version      = "1.0.3"
  s.summary      = "ShopApp Gateway description"
  s.homepage     = "https://github.com/rubygarage/shopapp-ios"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }
  s.author       = { "Mykola Voronin" => "nvoronin@rubygarage.org" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/rubygarage/shopapp-ios.git", :tag => "#{s.version}" }
  s.source_files = "ShopApp_Gateway/**/*.swift"
end
