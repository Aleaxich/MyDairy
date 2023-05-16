# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end

source 'https://github.com/CocoaPods/Specs.git'
target 'MyDairy' do
 pod 'AFNetworking', '~>4.0'
 pod 'Masonry'
 pod 'SnapKit', '~> 5.0'
 pod 'SVProgressHUD'
 pod 'ReactiveCocoa', '~> 10.1'
 pod 'RxSwift', '6.5.0'
 pod 'RxCocoa', '6.5.0'
 pod 'RxDataSources'
 pod 'Then'
 pod 'QWeather-SDK'
 pod 'AAChartKit'
 pod 'AAInfographics'
end
