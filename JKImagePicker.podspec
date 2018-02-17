Pod::Spec.new do |s|
  s.name             = 'JKImagePicker'
  s.version          = '0.1.3'
  s.summary          = 'An image cropper and camera feature like Instagram.'

  s.description      = <<-DESC
JKImagePicker is an image cropper and camera feature like Instagram. You can take square-sized photo from camera and also it comes with filters and some edits mode (Brightness, Constrast, Saturation....).
                       DESC

  s.homepage         = 'https://github.com/jamesTheKid/JKImagePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jamesTheKid' => 'kumako.jimmy@gmail.com' }
  s.source           = { :git => 'https://github.com/jamesTheKid/JKImagePicker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jamesthakid'

  s.ios.deployment_target = '9.0'

  s.source_files = ['JKImagePicker/Classes/**/*.swift']
  
  s.resources    = ['JKImagePicker/Assets/Assets.xcassets','JKImagePicker/Assets/**/*.xib']

  #s.resource_bundles = {
  #    'JKImagePicker' => ['JKImagePicker/Assets/**/*.xib']
  #  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
