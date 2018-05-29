Pod::Spec.new do |s|
  s.name     = 'Ortrofit'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A delightful iOS networking framework.'
  s.homepage = 'https://github.com/Oriente-iOS/Ortrofit'
  s.social_media_url = ''
  s.authors  = { 'Mathew Wang' => 'mathew.wang@oriente.com' }
  s.source   = { :git => 'https://github.com/Oriente-iOS/Ortrofit.git', :tag => s.version}
  s.requires_arc = true
  s.source_files = 'Ortrofit/Ortrofit/**/*.{h,m}'
  s.public_header_files = 'Ortrofit/Ortrofit/**/*.h'
  s.ios.deployment_target = '9.0'
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }


  # s.subspec 'CallAdaptor' do |ss|
  #   ss.dependency 'Ortrofit/OrtrofitCore'
  #   ss.dependency 'Ortrofit/SupportFiles'

  #   ss.source_files = 'Ortrofit/Ortrofit/CallAdaptor/**/*.{h,m}'
  #   ss.public_header_files = 'Ortrofit/Ortrofit/CallAdaptor/**/*.h'

  # end

  # s.subspec 'CallAdaptorRAC' do |ss|
  #   ss.dependency 'Ortrofit/OrtrofitCore'
  #   ss.dependency 'Ortrofit/SupportFiles'

  #   ss.source_files = 'Ortrofit/Ortrofit/CallAdaptorRAC/**/*.{h,m}'
  #   ss.public_header_files = 'Ortrofit/Ortrofit/CallAdaptorRAC/**/*.h'

  # end

  # s.subspec 'Ortrofit' do |ss|
  #   ss.source_files = 'Ortrofit/Ortrofit/Ortrofit/**/*.{h,m}','Ortrofit/Ortrofit/SupportFiles/*.{h,m}','Ortrofit/Ortrofit/OrtroProxy/*.{h,m}'
  #   ss.public_header_files = 'Ortrofit/Ortrofit/Ortrofit/**/*.h','Ortrofit/Ortrofit/SupportFiles/*.h','Ortrofit/Ortrofit/OrtroProxy/*.h'
  # end

  # s.subspec 'RequestAdaptor' do |ss|
  #   ss.dependency 'Ortrofit/SupportFiles'

  #   ss.source_files = 'Ortrofit/Ortrofit/RequestAdaptor/*.{h,m}'
  #   ss.public_header_files = 'Ortrofit/Ortrofit/RequestAdaptor/*.h'
  # end

  # s.subspec 'ResponseAdaptor' do |ss|
  #   ss.dependency 'Ortrofit/SupportFiles'

  #   ss.source_files = 'Ortrofit/Ortrofit/ResponseAdaptor/*.{h,m}'
  #   ss.public_header_files = 'Ortrofit/Ortrofit/ResponseAdaptor/*.h'
  # end

  s.dependency 'AFNetworking', '3.1.0'
  s.dependency 'ReactiveCocoa', '2.5'

end