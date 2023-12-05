Pod::Spec.new do |s|
  s.name          = 'RSKPlaceholderTextView'
  s.version       = '7.0.0'
  s.summary       = 'A light-weight UITextView subclass that adds support for placeholder.'
  s.homepage      = 'https://github.com/ruslanskorb/RSKPlaceholderTextView'
  s.license       = { :type => 'Apache', :file => 'LICENSE' }
  s.authors       = { 'Ruslan Skorb' => 'ruslan.skorb@gmail.com' }
  s.source        = { :git => 'https://github.com/ruslanskorb/RSKPlaceholderTextView.git', :tag => s.version.to_s }
  s.platform      = :ios, '12.0'
  s.swift_version = '5.7'
  s.source_files  = 'RSKPlaceholderTextView/*.{swift}'
  s.framework     = 'UIKit'
  s.requires_arc  = true
end
