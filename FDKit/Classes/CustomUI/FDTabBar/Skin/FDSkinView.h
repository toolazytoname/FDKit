//
//  FDCustomTabBarView.h
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/14.
//  Copyright © 2018年 weichao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDSkinView : UIView
@property(nonatomic,copy) void (^selectedIndexChanged) (NSUInteger currentIndex);
- (instancetype)initWithHeight:(CGFloat)height;
- (void)setSelectedBtnIndex:(NSInteger)btnIndex;
@end

NS_ASSUME_NONNULL_END
