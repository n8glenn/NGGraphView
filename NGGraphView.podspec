Pod::Spec.new do |s|
  s.name             = "NGGraphView"
  s.version          = "0.1.0"
  s.summary          = "A simple graph view for iOS."
  s.description      = <<-DESC
                       NGGraphView allows you to show how data changes over time using a graph.
                       DESC
  s.homepage         = "http://github.com/n8glenn/NGGraphView.git"
  #s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nate Glenn" => "n8glenn@gmail.com" }
  s.source           = { :git => "http://www.github.com/n8glenn/NGGraphView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/n8glenn'

  # s.platform     = :ios, '5.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes/ios/{NGGraphView, NGDataPoint}.{h, m}', 'Classes/ios/NGConstants.h'
  #s.resources = 'Assets/*.png'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation'
end
