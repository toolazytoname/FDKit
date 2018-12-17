//
//  CALayer+BPAAddition.m
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/19.
//  Copyright © 2018 weichao. All rights reserved.
//

#import "CALayer+BPAAddition.h"

@implementation CALayer (BPAAddition)

- (CABasicAnimation *)bpa_scaleAnamation {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1.0f);
    scale.toValue = @(0.5);
    scale.autoreverses = YES;
    scale.removedOnCompletion = YES;
    scale.fillMode = kCAFillModeForwards;
    return scale;
}

- (CABasicAnimation *)bpa_upAnimationWithStartY:(CGFloat)startY {
    CABasicAnimation *down = [CABasicAnimation animation];
    down.keyPath = @"position.y";
    down.fromValue = @(startY);
    down.toValue = @(startY - 19);
    
    down.fillMode = kCAFillModeForwards;
    down.removedOnCompletion = NO;
    return down;
}

- (void)bpa_addAnimations:(NSArray *)animations {
    if (!animations || animations.count == 0) {
        return;
    }
    [CATransaction begin];
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = animations;
    animGroup.duration = 0.15;
    [self addAnimation:animGroup forKey:@"bpa.tab"];
    [CATransaction commit];
}
@end
