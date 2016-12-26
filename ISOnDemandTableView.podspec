#
# Be sure to run `pod lib lint ISParse.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ISOnDemandTableView"
  s.version          = "0.1.0"
  s.summary          = "A standard implementation for on-demand content in tableView"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       A standard implementation for on-demand content in tableView
                       DESC

  s.homepage         = "https://bitbucket.org/ilhasoft/isparse"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Dielson Sales" => "dielson@ilhasoft.com.br" }
  s.source       = { :git => "https://bitbucket.org/ilhasoft/isparse.git", :branch => "master" }
  s.social_media_url   = "https://twitter.com/dielsonscarvalho"

  s.ios.deployment_target = '9.0'

  s.source_files = 'ISOnDemandTableView/*'

end
