project 'Users-test-task.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Users-test-task' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'AlamofireImage'
  pod 'Dip'
  pod 'NotificationBannerSwift'
  pod 'Cloudinary'
  pod 'Eureka'
  pod 'MMUploadImage'
  pod 'CustomLoader'

end

post_install do |installer|
        # Your list of targets here.
	myTargets = ['Cloudinary', 'MMUploadImage', 'CustomLoader']
	
	installer.pods_project.targets.each do |target|
		if myTargets.include? target.name
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '3.2'
			end
		end
	end
end
