//
//  BPWGuideView.h
//  AFNetworking
//
//  Created by Lazy on 2018/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 以萌主的类改编而来。架子沿用，改了一些细节。
 实现功能引导页，背景为半透明层，会在特定的位置按顺序展示一次图片。点击屏幕任意位置消失。
 */
@interface FDGuideView : UIView

/**
 展示功能引导页

 @param imageViewArray 图像视图数组
 @param imageFrameArray 对应的位置
 */
+ (void)showWithImageViewArray:(NSArray <UIImageView *>*)imageViewArray
               imageFrameArray:(NSArray <NSValue *>*)imageFrameArray;
@end

NS_ASSUME_NONNULL_END
