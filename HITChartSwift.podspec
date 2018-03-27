#
#  Be sure to run `pod spec lint HITChartSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "HITChartSwift"
  s.version      = "0.0.1"
  s.summary      = "A bitcoin and stock chart lib for iOS."
  s.license      = "MIT"
  s.author       = { "hitsubunnu" => "idhitsu@gmail.com" }
  s.swift_version = "4.0"
  s.platform     = :ios
  s.source       = { :git => "git@github.com:hitsubunnu/HITChartSwift.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
end
