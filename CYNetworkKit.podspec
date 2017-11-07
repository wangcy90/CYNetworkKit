Pod::Spec.new do |s|
  s.name             = 'CYNetworkKit'
  s.version          = '1.0.0'
  s.summary          = 'CYNetworkKit is a request util based on AFNetworking.'
  s.homepage         = 'https://github.com/wangcy90/CYNetworkKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WangChongyang' => 'chongyangfly@163.com' }
  s.source           = { :git => 'https://github.com/wangcy90/CYNetworkKit.git', :tag => s.version }
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.source_files = 'CYNetworkKit/**/*'
  s.dependency 'AFNetworking', '~> 3.1.0'
end
