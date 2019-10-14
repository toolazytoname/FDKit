//
//  FDCustomTabItemView.m
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import "FDSkinItemView.h"
#import "FDSkinManager.h"

#import "UIView+FDAdd.h"
#import "NSArray+FDAdd.h"
#import "CALayer+FDAddition.h"




@interface FDSkinItemView()
@property(nonatomic, strong) UIImage *norImage;
@property(nonatomic, strong) UIImage *preImage;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign, readonly) NSUInteger index;
@property(nonatomic, assign) BOOL selected;
@end

@implementation FDSkinItemView

#define imageLength 62.0f
#define imageTop -3.0f
#define imageAnimationTop -3.0f - 19.0f

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame norImage:(UIImage *)norImage preImage:(UIImage *)preImage {
    self = [super initWithFrame:frame];
    if (self) {
        if (norImage) {
            _norImage = norImage;
        }
        if (preImage) {
            _preImage = preImage;
        }
        [self addSubview:self.imageView];
        [self addTapGesture];
    }
    return self;
}


- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWithGestureRecognizer:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - public
- (void)itemViewSelect {
    if(!self.selected){
        self.selected = YES;
        [self _resetBrotherCustomTabItemView];
    }
    !self.btnClicked?:self.btnClicked(self.index);
}


#pragma mark - Gesture
- (void)tapWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (BPTMessageCenter == self.index) {
        id<BPLProtocolLite> service = [[BPBServiceManager sharedManager] createService:@protocol(BPLProtocolLite)];
        [service determineNeedLoginWithRootVC:[BPTViewTools topViewController] finishBlock:^(NSInteger finishType) {
            [self itemViewSelect];
        } giveupBlock:nil];
    } else {
        [self itemViewSelect];
    }
    [self _startAnimation];
}

#pragma mark  - custom setter&getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        if (self.norImage) {
            _imageView.image = self.norImage;
        }
        _imageView.BPT_width = imageLength;
        _imageView.BPT_height = imageLength;
        _imageView.BPT_centerX = self.BPT_width/2;
        _imageView.BPT_top = imageTop;
    }
    return _imageView;
}

- (NSUInteger)index {
    NSUInteger index = round(self.BPT_left/self.BPT_width);
    return index;
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        selected?[self _selectedState]:[self _reset];
    }
}

#pragma mark -private method

- (void)_startAnimation {
    NSMutableArray *animationArray = [[NSMutableArray alloc] init];
    if ([FDSkinManager shouldPerformScaleAnimation]) {
        [animationArray BPT_addObj:[self.imageView.layer FD_scaleAnamation]];
    }
    if ([FDSkinManager shouldPerformMoveAnimation]) {
        [animationArray BPT_addObj:[self.imageView.layer FD_upAnimationWithStartY:self.BPT_height/2 + imageTop]];
    }
    [self.imageView.layer FD_addAnimations:animationArray];
}

- (void)_resetBrotherCustomTabItemView {
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:self.class] && obj != self) {
            [(FDSkinItemView *)obj setSelected:NO];;
        }
    }];
}

- (void)_reset {
    self.imageView.BPT_top = imageTop;
    self.imageView.image = self.norImage;
}

- (void)_selectedState {
    if ([FDSkinManager shouldPerformMoveAnimation]) {
        self.imageView.BPT_top = imageAnimationTop;
    }
    self.imageView.image = self.preImage;
}
@end
