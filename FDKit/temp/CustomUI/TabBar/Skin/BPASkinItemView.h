//
//  BPACustomTabItemView.h
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPASkinItemView : UIView
- (instancetype)initWithFrame:(CGRect)frame norImage:(UIImage *)norImage preImage:(UIImage *)preImage;
@property(nonatomic,copy) void (^btnClicked)(NSUInteger index);
- (void)itemViewSelect;
@end

NS_ASSUME_NONNULL_END
