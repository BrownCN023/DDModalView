Pod::Spec.new do |s|

s.name         = "DDModalView"
s.version      = "0.1.3"
s.summary      = "弹出框alert、action及自定义。"
s.homepage     = "https://github.com/BrownCN023/DDModalView"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "liyebiao1990" => "347991555@qq.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/BrownCN023/DDModalView.git", :tag => s.version }
s.source_files = "DDModalView/*.{h,m}"
s.requires_arc = true
s.frameworks = "UIKit", "Foundation"

s.dependency "Masonry", "~> 1.1.0"

end
