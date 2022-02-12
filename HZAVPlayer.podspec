#
# Be sure to run `pod lib lint RTCCommon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HZAVPlayer'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HZAVPlayer.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aliyunvideo/HZAVPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sky' => '' }
  s.source           = { :git => '', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  # s.source_files = '**/*.{h,m,mm}'
  s.subspec 'Classess' do |ss|
    # rtcsdk.resource = 'AlivcLibFaceResource.bundle'
    ss.source_files = "HZAVPlayer/HZAVPlayer/HZAVPlayer/**/*.{h,m}"
  end



   #s.ios.vendored_frameworks = 'MTSDK/Framework/*.framework'
   # s.resources = "MTSDK/Resources/**"
  s.resource_bundles = {
   'HZAVPlayerBundles' => ['HZAVPlayer/HZAVPlayer/Resources/**/*']
  }

  
  # s.resources  = 'RTCCommon/RTCCommon.bundle','RTCCommon/*.storyboard'
  
  # s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  
  # s.resource_bundles = {
  #   'RTCCommon' => ['RTCCommon/Assets/*.png']
  # }


 s.framework  = "MobileCoreServices"
 s.requires_arc = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
end
