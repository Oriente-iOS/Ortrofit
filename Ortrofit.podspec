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
  s.source_files = 'Ortrofit/Ortrofit/*.{h,m}'
  s.ios.deployment_target = '7.0'
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

  s.subspec 'SupportFiles' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/SupportFiles/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/SupportFiles/*.h'
  end

  s.subspec 'RequestAdaptor' do |ss|
    ss.dependency 'Ortrofit/SupportFiles'

    ss.source_files = 'Ortrofit/Ortrofit/RequestAdaptor/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/RequestAdaptor/*.h'
  end

  s.subspec 'ResponseAdaptor' do |ss|
    ss.dependency 'Ortrofit/SupportFiles'

    ss.source_files = 'Ortrofit/Ortrofit/ResponseAdaptor/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/ResponseAdaptor/*.h'
  end

  s.subspec 'OrtroProxy' do |ss|
    ss.dependency 'Ortrofit/SupportFiles'

    ss.source_files = 'Ortrofit/Ortrofit/OrtroProxy/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/OrtroProxy/*.h'
  end

  s.subspec 'OrtrofitCore' do |ss|
    ss.dependency 'Ortrofit/OrtroProxy'
    ss.dependency 'Ortrofit/SupportFiles'

    ss.source_files = 'Ortrofit/Ortrofit/Ortrofit/**/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/Ortrofit/**/*.h'
  end

  s.subspec 'CallAdaptor' do |ss|
    ss.dependency 'Ortrofit/OrtrofitCore'
    ss.dependency 'Ortrofit/SupportFiles'

    ss.source_files = 'Ortrofit/Ortrofit/CallAdaptor/**/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/CallAdaptor/**/*.h'

  end

  s.subspec 'CallAdaptorRAC' do |ss|
    ss.dependency 'Ortrofit/OrtrofitCore'
    ss.dependency 'Ortrofit/SupportFiles'

    ss.source_files = 'Ortrofit/Ortrofit/CallAdaptorRAC/**/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/CallAdaptorRAC/**/*.h'

  end

  s.subspec 'OrtrofitConvenient' do |ss|
    ss.dependency 'Ortrofit/OrtrofitCore'
    ss.dependency 'Ortrofit/SupportFiles'
    ss.dependency 'Ortrofit/CallAdaptor'
    ss.dependency 'Ortrofit/CallAdaptorRAC'
    ss.dependency 'Ortrofit/RequestAdaptor'
    ss.dependency 'Ortrofit/ResponseAdaptor'


    ss.source_files = 'Ortrofit/Ortrofit/OrtrofitConvenient/**/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/OrtrofitConvenient/**/*.h'
  end

  s.dependency 'AFNetworking', '3.1.0'
  s.dependency 'ReactiveCocoa', '2.5'

end