//
//  BPWGuideView.m
//  AFNetworking
//
//  Created by Lazy on 2018/10/12.
//

#import "BPWGuideView.h"
#import "BPTAppMacro.h"
#import "UIColor+BPTAdditions.h"
#import "NSArray+BPTSafe.h"
#import "BPWUtil.h"
#import "UIView+BPTAdditions.h"

@interface BPWGuideView()
@property (nonatomic, strong) UIView  *bgView;         //半透明层;
@property (nonatomic, strong) NSArray *imageNameViewArray; //引导视图
@property (nonatomic, strong) NSArray *imageFrameArray; //图片显示位置
@property (nonatomic, assign) NSUInteger indexToShow;
@end

@implementation BPWGuideView
static NSString *keyOfGuideHasShown = @"BPWGuideHasShownKey";

+ (void)showGuideViewWithImageNameArray:(NSArray *)imageNameArray
                          imageFrameArray:(NSArray *)imageFrameArray {
    BOOL hasShown = [[NSUserDefaults standardUserDefaults] boolForKey:keyOfGuideHasShown];
    if (hasShown) {
        return;
    }
    // 如果window上已存在guide则移除
    NSArray<UIView *> *subViewsOfWindow = [[[UIApplication sharedApplication] keyWindow] subviews];
    [subViewsOfWindow enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BPWGuideView class]]) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    
    if (imageNameArray.count > 0) {
        // 初始化guideView并添加到window上
        BPWGuideView *guideView = [[BPWGuideView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)
                                                   imageNameArray:imageNameArray
                                                   imageFrameArray:imageFrameArray];
        [[[UIApplication sharedApplication] keyWindow] addSubview:guideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyOfGuideHasShown];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    //点击任意位置，关闭guide
    if(CGRectContainsPoint(self.bgView.frame, touchPoint)) {
        if(self.indexToShow < self.imageFrameArray.count) {
            [self setupNextImageView];
        }
        else{
            [self removeFromSuperview];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
           imageNameArray:(NSArray *)imageNameViewArray
           imageFrameArray:(NSArray *)imageFrameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageNameViewArray = imageNameViewArray;
        self.imageFrameArray = imageFrameArray;
        self.indexToShow = 0;
        [self addSubview:self.bgView];
        [self setupNextImageView];
    }
    return self;
}

- (void)setupNextImageView {
    [self clean];
    NSString *imageName = [self.imageNameViewArray BPT_objAtIndex:self.indexToShow];
    CGRect imageFrame = [[self.imageFrameArray BPT_objAtIndex:self.indexToShow] CGRectValue];
    UIImage *image = [BPWUtil imageInBundleWithName:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = imageFrame;
    [self.bgView addSubview:imageView];
    self.indexToShow++;
}

- (void)clean {
    if (self.bgView.subviews.count > 0) {
        [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
        _bgView.backgroundColor = [UIColor BPT_colorWithHexString:@"#000000" withAlpha:0.8f];
    }
    return _bgView;
}


@end
