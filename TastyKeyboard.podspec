#
# Be sure to run `pod lib lint tasty-keyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TastyKeyboard'
  s.version          = '0.1.0'
  s.summary          = 'Swift keyboard imitation of native keyboard'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
3rd Party keyboard that imitates a en-US native iOS Keyboard, and can be used as the base for custom
keyboard implementations in Swift.
                       DESC

  s.homepage         = 'https://github.com/UnifyBadPirate/tasty-imitation-keyboard'
  s.screenshots     = 'https://github.com/UnifyBadPirate/tasty-imitation-keyboard/raw/master/Screenshot-Portrait.png', 'https://github.com/UnifyBadPirate/tasty-imitation-keyboard/raw/master/Screenshot-Landscape.png'
  s.license          = { :type => 'BSD3', :file => 'LICENSE' }
  s.author           = { 'UnifyBadPirate' => 'kevin@unify.id' }
  s.source           = { :git => 'https://github.com/UnifyBadPirate/tasty-imitation-keyboard.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_versions = ['4.2','5.0']

  s.source_files = 'Keyboard/*.swift'
  
  s.resource_bundles = {
    'tasty-keyboard' => ['Keyboard/*.{xib,xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end

