platform :ios, '11.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'Lexor_iOS_ShopOwnerEmployee' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'Moya'
  pod 'SDWebImage'
  pod 'SVProgressHUD'
  pod 'SnapKit'
  pod 'ReachabilitySwift'
  pod 'JWTDecode', '~> 2.6'
  pod 'AFNetworking', '1.2.0'
  pod 'Firebase/Messaging'
  pod 'DropDown'
  pod 'TagListView'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end

