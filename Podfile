# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'ShopClient' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShopClient
  pod 'Mobile-Buy-SDK', '~> 3.1'

  # UI
  pod 'SDWebImage', '~> 4.1'
  pod 'MBProgressHUD', '~> 1.0'
  pod 'UIScrollView-InfiniteScroll', '~> 1.0'
  pod 'SKPhotoBrowser', '~> 5.0'
  pod 'TPKeyboardAvoiding', '~> 1.3'
  pod 'Toaster', '~> 2.1'
  pod 'AvatarImageView', '~> 2.1'
  pod 'SwipeCellKit', '~> 2.0'
  pod 'UIImage+Additions', '~> 2.1'
  pod 'TTTAttributedLabel', '~> 2.0'
  
  # Database
  pod 'CoreStore', '~> 4.2'

  # Architecture
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'

  # Secutity
  pod 'KeychainSwift', '~> 10.0'

  # Payment
  pod 'MFCard', '~> 1.2'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if ['AvatarImageView', 'MFCard', 'SKPhotoBrowser', 'SwipeCellKit'].include? target.name
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end
    end
  end

end
