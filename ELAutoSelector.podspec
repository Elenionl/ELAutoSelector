
Pod::Spec.new do |s|

  s.name         = "ELAutoSelector"
  s.version      = "1.0.0"
  s.summary      = "A light-weight tool helps developers use block for 'target action' kind methods"
  s.description  = <<-DESC
  If you feel `- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;` is too complex to use, try ELAutoSelector.
  It is very easy to use:
  
  #import "ELAutoSelectorHelper.h"
  ...
  // In implementation
    [myButton addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        ...
        // What you want to do
    }, self) forControlEvents:UIControlEventTouchUpInside];
  ...
                   DESC
  s.homepage     = "https://github.com/Elenionl/ELAutoSelector"
  s.license      = { :type => 'Apache 2.0', :file => 'LICENSE.md' }
  s.author             = { "Hanping Xu" => "stellanxu@gmail.com" }
  s.social_media_url   = "https://github.com/Elenionl"
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/Elenionl/ELAutoSelector.git", :tag => "#{s.version}" }
  s.source_files  = "ELAutoSelectorHelper/*"
  s.requires_arc = true
  s.frameworks = 'Foundation'
end
# pod spec lint ELAutoSelector.podspec
# pod trunk push ELAutoSelector.podspec
