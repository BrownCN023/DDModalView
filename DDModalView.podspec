#
#  Be sure to run `pod spec lint DDToolbox.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "DDModalView"
s.version      = "0.0.4"
s.summary      = "弹出框alert、action及自定义。"
s.homepage     = "https://github.com/BrownCN023/DDModalView"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "liyebiao1990" => "347991555@qq.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/BrownCN023/DDModalView.git", :tag => s.version }
s.source_files = "DDModalView/*.{h,m}"
s.requires_arc = true
s.frameworks = "Foundation"

s.dependency "Masonry", "~> 1.1.0"

end
