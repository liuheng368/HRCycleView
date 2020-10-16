Pod::Spec.new do |s|

  s.name         = "HRCycleView"
  s.version      = "1.0.1"
  s.summary      = "用UICollectionView实现的轮播图，带进度条样式"
  s.homepage     = "https://github.com/liuheng368/HRCycleView/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Henry" => "lhappledev@163.com" }
  s.social_media_url   = "https://henry.beer"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/liuheng368/HRCycleView.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.requires_arc = true
  s.dependency "Kingfisher"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
