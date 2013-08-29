Pod::Spec.new do |s|
  s.name          = 'UIDevice-Extension'
  s.version       = '0.0.2'
  s.platform      = :ios
  s.summary       = 'UIDevice categories to determine device model'
  s.homepage      = 'https://github.com/erica/uidevice-extension'
  s.author        = 'erica'
  s.source        = { :git  => 'https://github.com/jnstq/uidevice-extension' }
  s.source_files  = "wanconnect.{h,c}"

  s.subspec 'Hardware' do |hard|
    hard.source_files  = 'UIDevice-Hardware.{h,m}'
  end
  s.subspec 'Reachability' do |reach|
    reach.source_files  = 'UIDevice-Reachability.{h,m}'
  end
end
