//
//  BPWGuideView.h
//  AFNetworking
//
//  Created by Lazy on 2018/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPWGuideView : UIView

+ (void)showGuideViewWithImageNameArray:(NSArray *)imageNameArray
                        imageFrameArray:(NSArray *)imageFrameArray;
@end

NS_ASSUME_NONNULL_END
