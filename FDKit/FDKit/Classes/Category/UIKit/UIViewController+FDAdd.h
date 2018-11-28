//
//  UIViewController+FDAdd.h
//  FDCategories
//
//  Created by weichao on 2018/11/19.
//  Copyright © 2018年 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FDAdd)
- (void)fd_addViewController:(UIViewController *)subViewController;

- (void)fd_addViewController:(UIViewController *)subViewController containerView:(UIView *)containerView;

- (void)fd_removeFromParentViewController;

- (void)fd_popAndPushViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
