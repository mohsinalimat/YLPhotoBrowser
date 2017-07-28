Pod::Spec.new do |s|
  s.name             = 'YLPhotoBrowser'
  #版本号，默认从0.1.0开始
  s.version          = '0.1.0'
  s.summary          = '仿微信图片浏览器(定义转场动画、支持本地和网络gif、拖拽取消）'

  s.description      = <<-DESC
                        仿微信图片浏览器(定义转场动画、支持本地和网络gif、拖拽取消）
                       DESC
  s.homepage         = 'https://github.com/February12/YLPhotoBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yl' => '845369698@qq.com' }
                                               
  s.source           = { 
                        :git => 'https://github.com/February12/YLPhotoBrowser.git', 
                        :tag => s.version.to_s 
                       }

  s.ios.deployment_target = '8.0'
  s.platform     = :ios, '8.0'
  s.source_files = 'YLPhotoBrowser/YLPhotoBrowser/**/*'

  s.requires_arc = true
  s.framework = "MobileCoreServices"

  s.dependency 'Kingfisher', '~> 3.10.2'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

end