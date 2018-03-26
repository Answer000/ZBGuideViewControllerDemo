Pod::Spec.new do |s|
    s.name         = 'ZBGuideViewController'
    s.version      = '0.0.3'
    s.summary      = '实现引导页和广告图功能，可定制性高'
    s.homepage     = 'https://github.com/AnswerXu/ZBGuideViewControllerDemo.git'
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "AnswerXu" => "zhengbo073017@163.com" }
    s.source       = { :git => 'https://github.com/AnswerXu/ZBGuideViewControllerDemo.git', :tag => s.version.to_s }
    s.platform     = :ios, '8.0'
    s.source_files = 'ZBGuideViewControllerDemo/ZBGuideViewController/*.{h,m}',
    s.framework    = 'UIKit'
    s.requires_arc = true
    s.dependency 'SDWebImage', '~> 3.7'
end
