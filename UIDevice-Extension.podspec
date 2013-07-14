Pod::Spec.new do |s|
  s.name          = 'UIDevice-Extension'
  s.version       = '0.0.1'
  s.platform      = :ios
  s.summary       = 'UIDevice categories to determine device model'
  s.homepage      = 'https://github.com/erica/uidevice-extension'
  s.author        = 'erica'
  s.source        = { :git  => 'https://github.com/pilot34/uidevice-extension' }
  s.source_files = ""

  s.subspec 'Hardware' do |hard|
    hard.source_files  = 'UIDevice-Hardware.{h,m}'
  end
end
