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
@property (nonatomic, strong) UIView  *bgView;         //半透明层;
@property (nonatomic, strong) NSArray <UIImageView *>*imageViewArray; //引导视图
@property (nonatomic, strong) NSArray <NSValue *>*imageFrameArray; //图片显示位置
@property (nonatomic, assign) NSUInteger indexToShow;
@end

@implementation FDGuideView
static NSString *keyOfGuideHasShown = @"BPWGuideHasShownKey";

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
    
    if (imageViewArray.count > 0) {
        // 初始化guideView并添加到window上
        FDGuideView *guideView = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                   imageViewArray:imageViewArray
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
           imageViewArray:(NSArray *)imageViewArray
           imageFrameArray:(NSArray *)imageFrameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageViewArray = imageViewArray;
        self.imageFrameArray = imageFrameArray;
        self.indexToShow = 0;
        [self addSubview:self.bgView];
        [self setupNextImageView];
    }
    return self;
}

- (void)setupNextImageView {
    [self clean];
    UIView *imageView = [self.imageViewArray fd_objectOrNilAtIndex:self.indexToShow];
    CGRect imageFrame = [[self.imageFrameArray fd_objectOrNilAtIndex:self.indexToShow] CGRectValue];
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
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        _bgView.backgroundColor = [UIColor BPT_colorWithHexString:@"#000000" withAlpha:0.8f];
        _bgView.backgroundColor = FDColorHex(000000CC);
    }
    return _bgView;
}


@end
