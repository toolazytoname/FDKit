//
//  UIViewController+FDAdd.m
//  FDCategories
//
//  Created by weichao on 2018/11/19.
//  Copyright © 2018年 ibireme. All rights reserved.
//

#import "UIViewController+FDAdd.h"

@implementation UIViewController (FDAdd)
- (void)fd_addViewController:(UIViewController *)subViewController{
    [self addChildViewController:subViewController];
    [self.view addSubview:subViewController.view];
    [subViewController didMoveToParentViewController:self];
}

- (void)fd_addViewController:(UIViewController *)subViewController containerView:(UIView *)containerView {
    [self addChildViewController:subViewController];
    [containerView addSubview:subViewController.view];
    [subViewController didMoveToParentViewController:self];
}

- (void)fd_removeFromParentViewController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)fd_popAndPushViewController:(UIViewController *)viewController {
    NSMutableArray *viewControllersInStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllersInStack removeLastObject];
    [viewControllersInStack addObject:viewController];
    [self.navigationController setViewControllers:viewControllersInStack animated:YES];
}

@end
