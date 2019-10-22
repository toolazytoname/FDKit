//
//  UIImageView+FDAdd.m
//  FDKit
//
//  Created by Lazy on 2019/10/15.
//
#import "UIImageView+FDAdd.h"
#import "UIImage+FDAdd.h"


@implementation UIImageView (FDAdd)
- (void)quickSetCornerRadius:(CGFloat)cornerRadius
{
    self.image = [self.image fd_imageByRoundCornerRadius:cornerRadius];
}

@end
