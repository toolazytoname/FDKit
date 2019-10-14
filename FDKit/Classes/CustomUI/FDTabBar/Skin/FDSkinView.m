//
//  FDCustomTabBarView.m
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/14.
//  Copyright © 2018年 weichao. All rights reserved.
//

#import "FDSkinView.h"
#import "FDSkinManager.h"
#import "FDSkinItemView.h"

#import "UIImage+FDAdd.h"
#import "NSArray+FDAdd.h"
#import "BPBNotificationCenter.h"

#define SystemTabBarHeight 49
#define FDSkinViewDefaultSelected 0

@interface FDSkinView()
@property (nonatomic, assign) CGFloat tabHeight;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation FDSkinView
#pragma mark -life cycle
- (instancetype)initWithHeight:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0, SystemTabBarHeight - height, MIN(MAINHEIGHT, MAINWIDTH), height + kSafeBottomMargin)];
    if (self) {
        self.tabHeight = height;
        UIImage *tabBackgroundImage = [FDSkinManager sharedManager].tabBackgroundImage;
        NSArray *norImages = [FDSkinManager sharedManager].norImages;
        NSArray *preImages = [FDSkinManager sharedManager].preImages;
        [self initWithBackgroundImage:tabBackgroundImage norImages:norImages preImaes:preImages];
        [self setSelectedBtnIndex:FDSkinViewDefaultSelected];
    }
    return self;
}

- (void)initWithBackgroundImage:(UIImage *)backgroundImage norImages:(NSArray *)norImages preImaes:(NSArray *)preImages {
    UIImage *resizedImage = [backgroundImage BPT_resizeImageWithNewSize:CGSizeMake(MAINWIDTH, MAINWIDTH * backgroundImage.size.height/backgroundImage.size.width)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:resizedImage];
    backgroundImageView.contentMode = UIViewContentModeTop;
    backgroundImageView.frame = self.bounds;
    [self addSubview:backgroundImageView];
    
    CGFloat itemWidth = MAINWIDTH/norImages.count;
    __weak typeof(self) weakSelf = self;
    [norImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *preImage = [preImages BPT_objAtIndex:idx];
        CGRect itemFrame = CGRectMake(idx*itemWidth, 0, itemWidth, self.tabHeight);
        FDSkinItemView *tabItemView = [[FDSkinItemView alloc] initWithFrame:itemFrame norImage:obj preImage:preImage];
        tabItemView.tag = [self _skinItemViewTagWithIndex:idx];
        tabItemView.btnClicked = ^(NSUInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.selectedIndex = index;
        };
        [self addSubview:tabItemView];
    }];
}

#pragma mark - public
- (void)setSelectedBtnIndex:(NSInteger)btnIndex {
//    self.selectedIndex = btnIndex;
    FDSkinItemView *tabItemView = [self viewWithTag:[self _skinItemViewTagWithIndex:btnIndex]];
    [tabItemView itemViewSelect];
}

#pragma mark - private
- (NSUInteger)_skinItemViewTagWithIndex:(NSUInteger)index{
    return 1000 + index;
}

#pragma mark - 重写set方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        self.selectedIndexChanged(selectedIndex);
    }
    [[BPBNotificationCenter defaultCenter] podcastEvent:BPBTabChangeEvent withParam:@{@"from":@(_selectedIndex),@"to":@(selectedIndex)}];
}

@end
