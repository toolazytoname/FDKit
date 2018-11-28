//
//  BPWGuideView.h
//  AFNetworking
//
//  Created by Lazy on 2018/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDGuideView : UIView

+ (void)showWithImageViewArray:(NSArray <UIImageView *>*)imageViewArray
               imageFrameArray:(NSArray <NSValue *>*)imageFrameArray;
@end

NS_ASSUME_NONNULL_END
