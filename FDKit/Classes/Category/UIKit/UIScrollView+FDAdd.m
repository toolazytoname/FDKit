//
//  UIScrollView+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIScrollView+FDAdd.h"
#import "FDCategoriesMacro.h"

FDSYNTH_DUMMY_CLASS(UIScrollView_FDAdd)


@implementation UIScrollView (FDAdd)

- (NSUInteger)fd_currentIndex {
    return self.contentOffset.x / CGRectGetWidth(self.bounds);
}

- (void)fd_scrollToTop {
    [self fd_scrollToTopAnimated:YES];
}

- (void)fd_scrollToBottom {
    [self fd_scrollToBottomAnimated:YES];
}

- (void)fd_scrollToLeft {
    [self fd_scrollToLeftAnimated:YES];
}

- (void)fd_scrollToRight {
    [self fd_scrollToRightAnimated:YES];
}

- (void)fd_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)fd_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)fd_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)fd_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

- (void)fd_scrollToIndex:(NSUInteger)index animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(index * CGRectGetWidth(self.bounds), 0.0f);
        }];
    }
    else{
        self.contentOffset = CGPointMake(index * CGRectGetWidth(self.bounds), 0.0f);
    }
    
}

@end
