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

  s.subspec 'SupportFiles' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/ServiceCall/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/ServiceCall/*.h'
  end

  s.subspec 'Utility' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/Utility/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/Utility/*.h'
    ss.dependency 'Ortrofit/SupportFiles'
  end

  s.subspec 'RequestAdaptor' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/RequestAdaptor/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/RequestAdaptor/*.h'

    ss.dependency 'Ortrofit/Utility'
    ss.dependency 'Ortrofit/SupportFiles'
  end

  s.subspec 'ResponseAdaptor' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/ResponseAdaptor/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/ResponseAdaptor/*.h'

    ss.dependency 'Ortrofit/Utility'
    ss.dependency 'Ortrofit/SupportFiles'
  end

  s.subspec 'CallAdaptor' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/CallAdaptor/**/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/CallAdaptor/**/*.h'
    ss.ios.frameworks = 'MobileCoreServices', 'CoreGraphics'

    ss.dependency 'Ortrofit/Utility'
    ss.dependency 'Ortrofit/SupportFiles'
  end

  s.subspec 'OrtroProxy' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/OrtroProxy/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/OrtroProxy/*.h'

    ss.dependency 'Ortrofit/Utility'
    ss.dependency 'Ortrofit/SupportFiles'
  end

  s.subspec 'ServiceCall' do |ss|
    ss.source_files = 'Ortrofit/Ortrofit/SupportFiles/*.{h,m}'
    ss.public_header_files = 'Ortrofit/Ortrofit/SupportFiles/*.h'

    ss.dependency 'Ortrofit/Utility'
    ss.dependency 'Ortrofit/SupportFiles'
  end

  s.dependency 'AFNetworking', '3.1.0'
  s.dependency 'ReactiveCocoa', '2.5'

end