#
# Be sure to run `pod lib lint ISParse.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ISOnDemandTableView"
  s.version          = "2.0.0"
  s.summary          = "A standard implementation for on-demand content in tableView"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       ISOnDemandTableView is a standard implementation for on-demand content in tableView that allows you to download content as you scroll
                       DESC

  s.homepage         = "https://github.com/Ilhasoft/ISOnDemandTableView"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Dielson Sales" => "dielson@ilhasoft.com.br" }
  s.source           = { :git => "https://github.com/Ilhasoft/ISOnDemandTableView.git", :tag => "1.0.0" }
  s.social_media_url = "https://twitter.com/dielsonsaless"

  s.ios.deployment_target = '9.0'

  s.source_files = 'ISOnDemandTableView/*.h', 'ISOnDemandTableView/*.m'

end
