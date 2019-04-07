
Pod::Spec.new do |s|
  s.name             = 'FDKit'
  s.version          = '0.1.0'
  s.summary          = 'My personal SwissArmyKnife'

  s.description      = <<-DESC
My personal SwissArmyKnife.
                       DESC

  s.homepage         = 'https://github.com/toolazytoname/FDKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'toolazytoname' => 'shuitaiyang747@qq.com' }
  s.source           = { :git => 'https://github.com/toolazytoname/FDKit.git', :tag => s.version.to_s }

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

  s.subspec 'Inherited' do |base|
      base.source_files = 'FDKit/Classes/Inherited/**/*.{h,m}'
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
      #      ui.subspec 'FDTabBar' do |tabbar|
      #   tabbar.source_files = 'FDKit/Classes/CustomUI/FDTabBar/*.{h,m}'
      #end
  end
  s.subspec 'Debug' do |debug|
      debug.subspec 'DebugObserver' do |debugobserver|
          debugobserver.source_files = 'FDKit/Classes/Debug/DebugObserver/**/*.{h,m}'
      end
      debug.subspec 'HitTestInspect' do |hittestinspect|
          hittestinspect.source_files = 'FDKit/Classes/Debug/HitTestInspect/**/*.{h,m}'
          hittestinspect.dependency 'Aspects'
      end
  end
  # s.subspec 'Utility' do |utility|
  #     utility.subspec 'AntiDebug' do |antidebug|
  #         antidebug.source_files = 'FDKit/Classes/Utility/AntiDebug/*.{h,m}'
  #     end
  #     utility.subspec 'Confuse' do |confuse|
  #         confuse.source_files = 'FDKit/Classes/Utility/Confuse/*'
  #     end
  #     utility.subspec 'NetWork' do |netWork|
  #         netWork.source_files = 'FDKit/Classes/Utility/NetWork/*.{h,m}'
  #         netWork.dependency 'AFNetworking'
  #         netWork.dependency 'YYCache'
  #     end
  #     utility.subspec 'FMDB' do |fmdb|
  #         fmdb.source_files = 'FDKit/Classes/Utility/FMDB/*.{h,m}'
  #         fmdb.dependency 'FMDB'
  #     end
  #     utility.subspec 'BootingProtection' do |bootingProtection|
  #         bootingProtection.source_files = 'FDKit/Classes/Utility/FDBootingProtection/*.{h,m}'
  #     end
  #     utility.subspec 'GuideView' do |guideView|
  #         guideView.source_files = 'FDKit/Classes/Utility/GuideView/*.{h,m}'
  #         guideView.dependency 'FDKit/Category'
  #     end
  #     utility.subspec 'LeftAlignedFlowLayout' do |leftAlignedFlowLayout|
  #         leftAlignedFlowLayout.source_files = 'FDKit/Classes/Utility/LeftAlignedFlowLayout/*.{h,m}'
  #     end
  #     utility.subspec 'LocationCoordinate' do |locationCoordinate|
  #         locationCoordinate.source_files = 'FDKit/Classes/Utility/LocationCoordinate/*.{h,m}'
  #     end
  #     utility.subspec 'PerformanceMonitor' do |performanceMonitor|
  #         performanceMonitor.source_files = 'FDKit/Classes/Utility/PerformanceMonitor/*.{h,m}'
  #     end
  #     utility.subspec 'SKUDataFilter' do |dataFilter|
  #         dataFilter.source_files = 'FDKit/Classes/Utility/SKUDataFilter/*.{h,m}'
  #     end
  #     utility.subspec 'ThreadSafeMutableArray' do |mutableArray|
  #         mutableArray.source_files = 'FDKit/Classes/Utility/ThreadSafeMutableArray/*.{h,m}'
  #     end
  #     utility.subspec 'WebImagePrefetcher' do |webImagePrefetcher|
  #         webImagePrefetcher.source_files = 'FDKit/Classes/Utility/WebImagePrefetcher/*.{h,m}'
  #         webImagePrefetcher.dependency 'SDWebImage'
  #         webImagePrefetcher.dependency 'FDKit/Category'
  #     end
  #     utility.subspec 'Opereation' do |opereation|
  #         opereation.source_files = 'FDKit/Classes/Utility/Opereation/*.{h,m}'
  #         opereation.dependency 'FDKit/Category'
  #     end
  #     utility.subspec 'Crash' do |crash|
  #         crash.source_files = 'FDKit/Classes/Utility/Crash/*.{h,m}'
  #         crash.dependency 'KSCrash'
  #         crash.dependency 'FDKit/Utility/Log'
  #
  #     end
  #     utility.subspec 'Log' do |log|
  #         log.source_files = 'FDKit/Classes/Utility/Log/*.{h,m}'
  #         log.dependency 'CocoaLumberjack'
  #     end
  # end
end
