//
//  UIButton+FDAdd.h
//  FDCategories
//
//  Created by weichao on 2018/11/19.
//  Copyright © 2018年 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (FDAdd)
- (void)fd_sentPhoneCodeTimeMethodInSecond:(NSUInteger)duration;

- (void)fd_setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
