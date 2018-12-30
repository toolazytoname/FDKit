//
//  BPWGuideView.m
//  AFNetworking
//
//  Created by Lazy on 2018/10/12.
//

#import "FDGuideView.h"
#import "UIColor+FDAdd.h"
#import "NSArray+FDAdd.h"
#import "UIView+FDAdd.h"
#import "FDCGUtilities.h"

@interface FDGuideView()
@property (nonatomic, strong) UIView  *backgroundView;         //半透明层;
@property (nonatomic, strong) NSArray <UIImageView *>*imageViewArray; //引导视图
@property (nonatomic, strong) NSArray <NSValue *>*imageFrameArray; //图片显示位置
@property (nonatomic, assign) NSUInteger indexToShow;
@end

@implementation FDGuideView
static NSString *keyOfGuideHasShown = @"FDGuideHasShownKey";

+ (void)showWithImageViewArray:(NSArray <UIImageView *>*)imageViewArray
               imageFrameArray:(NSArray <NSValue *>*)imageFrameArray {
    BOOL hasShown = [[NSUserDefaults standardUserDefaults] boolForKey:keyOfGuideHasShown];
    if (hasShown) {
        return;
    }
    // 如果window上已存在guide则移除
    NSArray<UIView *> *subViewsOfWindow = [[[UIApplication sharedApplication] keyWindow] subviews];
    [subViewsOfWindow enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[FDGuideView class]]) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    //其中一个数组为空，或则两个数组的count不相等，则退出
    if (0 == imageViewArray.count || 0 == imageFrameArray.count || imageViewArray.count != imageFrameArray.count) {
        return;
    }
    // 初始化guideView并添加到window上
    FDGuideView *guideView = [[self alloc] _initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                          imageViewArray:imageViewArray
                                         imageFrameArray:imageFrameArray];
    [[[UIApplication sharedApplication] keyWindow] addSubview:guideView];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyOfGuideHasShown];
}

- (instancetype)_initWithFrame:(CGRect)frame
           imageViewArray:(NSArray *)imageViewArray
           imageFrameArray:(NSArray *)imageFrameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageViewArray = imageViewArray;
        self.imageFrameArray = imageFrameArray;
        self.indexToShow = 0;
        [self addSubview:self.backgroundView];
        [self _setupNextImageView];
    }
    return self;
}

- (void)_setupNextImageView {
    [self _clean];
    UIView *imageView = [self.imageViewArray fd_objectOrNilAtIndex:self.indexToShow];
    CGRect imageFrame = [[self.imageFrameArray fd_objectOrNilAtIndex:self.indexToShow] CGRectValue];
    imageView.frame = imageFrame;
    [self.backgroundView addSubview:imageView];
    self.indexToShow++;
}

- (void)_clean {
    if (self.backgroundView.subviews.count > 0) {
        [self.backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
}

#pragma mark - lazy load
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backgroundView.backgroundColor = FDColorHex(000000CC);
    }
    return _backgroundView;
}

#pragma mark - 手势
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    //点击任意位置，关闭guide
    if(CGRectContainsPoint(self.backgroundView.frame, touchPoint)) {
        if(self.indexToShow < self.imageFrameArray.count) {
            [self _setupNextImageView];
        }
        else{
            [self removeFromSuperview];
        }
    }
}

@end
