#
# Be sure to run `pod lib lint FDKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FDKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FDKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/toolazytoname/FDKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'toolazytoname' => 'shuitaiyang747@qq.com' }
  s.source           = { :git => 'https://github.com/toolazytoname/FDKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.subspec 'Category' do |category|
      category.requires_arc = true
      category.source_files = 'FDKit/Classes/Category/**/*.{h,m}'
      non_arc_files = 'FDKit/Classes/Category/NoArc/NSObject+FDAddForARC.{h,m}', 'FDKit/Classes/Category/NoArc/NSThread+FDAdd.{h,m}'
      category.exclude_files = non_arc_files
      category.subspec 'NoArc' do |na|
        na.source_files = non_arc_files
        na.requires_arc = false
      end
  end
  
  s.subspec 'Base' do |base|
      base.source_files = 'FDKit/Classes/Base/**/*.{h,m}'
      base.dependency 'FDKit/Category'
  end
  
  s.subspec 'CustomUI' do |ui|
      ui.subspec 'FDFontStateButton' do |fontStateButton|
          fontStateButton.source_files = 'FDKit/Classes/CustomUI/FDFontStateButton.{h,m}'
      end
      ui.subspec 'FDLineHeightLabel' do |lineHeightLabel|
          lineHeightLabel.source_files = 'FDKit/Classes/CustomUI/FDLineHeightLabel.{h,m}'
      end
      ui.subspec 'FDUnHighlightedButton' do |unHighlightedButton|
          unHighlightedButton.source_files = 'FDKit/Classes/CustomUI/FDUnHighlightedButton.{h,m}'
      end
  end
  
  s.subspec 'Debug' do |debug|
      debug.source_files = 'FDKit/Classes/Debug/**/*.{h,m}'
  end
  
  s.subspec 'Utility' do |utility|
      utility.source_files = 'FDKit/Classes/Utility/**/*.{h,m}'
      utility.dependency 'FDKit/Category'
      utility.dependency 'FMDB'
      utility.dependency 'SDWebImage'
      utility.dependency 'AFNetworking'
      utility.dependency 'YYCache'

  end
  
  # s.resource_bundles = {
  #   'FDKit' => ['FDKit/Assets/*.png']
  # }

  

end
