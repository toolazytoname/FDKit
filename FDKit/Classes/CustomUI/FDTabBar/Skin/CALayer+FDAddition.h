//
//  UILayer+FDAddition.h
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/19.
//  Copyright © 2018 weichao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (FDAddition)
- (CABasicAnimation *)FD_scaleAnamation;
- (CABasicAnimation *)FD_upAnimationWithStartY:(CGFloat)startY;
- (void)FD_addAnimations:(NSArray *)animations;
@end

NS_ASSUME_NONNULL_END
