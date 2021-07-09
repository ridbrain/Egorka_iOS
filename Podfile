# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'egorka' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'FINNBottomSheet', :git => 'https://github.com/finn-no/bottom-sheet-ios.git'
  pod 'DCKit'
  pod 'Hero'
  pod 'JMMaskTextField-Swift'
  pod 'IQKeyboardManagerSwift'
  pod 'SideMenu'
  
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  
  pod 'TinkoffASDKCore'
  pod 'TinkoffASDKUI'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
