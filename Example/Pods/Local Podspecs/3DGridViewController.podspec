#
# Be sure to run `pod lib lint 3DGridViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "3DGridViewController"
  s.version          = "0.1.2"
  s.summary          = "A custom, 3D grid-shaped, container ViewController."
  s.description      = <<-DESC
                       3DGridViewController is a custom container view controller that lets you navigate
                       through content view controllers in the 3 dimensions, and leaves you total control over
                       transition animations and interactivity.
                       DESC
  s.homepage         = "https://github.com/madbat/3DGridViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Matteo Battaglio" => "m4dbat@gmail.com" }
  s.source           = { :git => "https://github.com/madbat/3DGridViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/m4dbat'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'AWPercentDrivenInteractiveTransition', '~> 0.1'
end
