Pod::Spec.new do |s|
  s.name             = "RichEditorView"
  s.version          = "5.2.2"
  s.summary          = "Rich Text Editor for iOS written in Swift"
  s.homepage         = "https://github.com/cjwirth/RichEditorView"
  s.license          = 'BSD 3-clause'
  s.author           = { "Caesar Wirth" => "cjwirth@gmail.com" }
  s.source           = { :git => "https://github.com/Lapinou42/RichEditorView", :tag => s.version.to_s }

  s.platform     = :ios, '11.0'
  s.swift_version = '5.0'
  s.requires_arc = true

  s.source_files = 'RichEditorView/Classes/**/*'
  s.resources = [
      'RichEditorView/Assets/icons/*',
      'RichEditorView/Assets/editor/*'
    ]
    
  s.dependency 'Gridicons', '~> 0.19'
  
end
