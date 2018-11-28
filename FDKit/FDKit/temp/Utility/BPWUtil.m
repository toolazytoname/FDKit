//
//  BPWUtil.m
//  AFNetworking
//
//  Created by Yiche on 2018/8/7.
//

#import "BPWUtil.h"
#import "BPEResponseModel.h"
#import "BPBServiceManager.h"
#import "BPWMacro.h"
#import "BPTAppConfig.h"
#import "BPTWebPhotoBrowserProtocol.h"
#import "NSArray+BPTSafe.h"

#define BPWIdentifierTail @"identifier"





@implementation BPWUtil

+ (NSBundle *)currentBundle {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BPWelfareLib" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return resourceBundle;
}


+ (UIImage *)imageInBundleWithName:(NSString *)imageName {
    if (!imageName || imageName.length == 0) {
        return nil;
    }
    CGFloat scale = 2.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [UIScreen mainScreen].scale;
    }
    NSString *name = [NSString stringWithFormat:@"%@@%ix",imageName,(int)scale];
    NSString *imagePath = [[BPWUtil currentBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (UIImage *)sucessImage {
    return [self imageInBundleWithName:@"img_tishi_chenggong"];
}

+ (UIImage *)noDataImage {
    return [self imageInBundleWithName:@"img_tishi_zanwu"];
}

+ (UINib *)nibInBundleWithName:(NSString *)nibName {
    if (!nibName || nibName.length == 0) {
        return nil;
    }
    UINib *nib = [UINib nibWithNibName:nibName bundle:[self currentBundle]];
    return nib;
}

+ (NSString *)identifierWithViewName:(NSString *)viewName {
    if (!viewName || viewName.length == 0) {
        return nil;
    }
    return [viewName stringByAppendingString:BPWIdentifierTail];
}

+ (BOOL)isNull:(id)object {
    BOOL isNull = NO;
    if ([object isEqual:[NSNull null]]) {
        isNull = YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        isNull = YES;
    }
    else if (object == nil){
        isNull = YES;
    }
    return isNull;
}

+ (BOOL)handleError:(BPEResponseModel *)model {
    BOOL isReturn = NO;
    if (model.error ) {
        NSLog(@"请检查网络连接！");
        isReturn = YES;
    }
    if (BPEStatusSuccessCode != model.statusCode) {
        if (![BPWUtil isNull:model.message] && model.message && model.message.length > 0) {
            NSLog(@"%@",model.message);
        }
        isReturn = YES;
    }
    return isReturn;
}

+ (BPLForumUser *)sharedForumUser {
    id<BPLProtocol> BPLService = [self obtainBPLService];
    return BPLService.userInfo;
}

+ (id<BPLProtocol>)obtainBPLService {
    id<BPLProtocol> BPLService = [[BPBServiceManager sharedManager] createService:@protocol(BPLProtocol)];
    return BPLService;
}

+ (id<BPPMainProtocol>)obtainBPPService {
    id<BPPMainProtocol> BPPService  = [[BPBServiceManager sharedManager] createService:@protocol(BPPMainProtocol)];
    return BPPService;
}

+ (id<BPTSchemaProtocol>)obtainSchemaService {
    id<BPTSchemaProtocol> BPTSchemaService  = [[BPBServiceManager sharedManager] createService:@protocol(BPTSchemaProtocol)];
    return BPTSchemaService;
}
    
+ (id<BPBStatisticProtocol>)obtainStaticService {
    id<BPBStatisticProtocol> BPBStatisticService = [[BPBServiceManager sharedManager] createService:@protocol(BPBStatisticProtocol)];
    return BPBStatisticService;
}

+ (void)staticWithParameter:(NSDictionary *)parameter {
    [[self obtainStaticService] sendEventWithType:BPAPPClickEvent param:parameter];
}

+ (void)staticWithShareInteger:(NSUInteger)index {
    NSString *title = @"";
    switch (index) {
        case 1:{
            title = @"fenxiang_weixin";
            break;
        }
        case 2:{
            title = @"fenxiang_pengyouquan";
            break;
        }
        case 0:{
            title = @"fenxiang_weibo";
            break;
        }
        case 4:{
            title = @"fenxiang_qq";
            break;
        }
        case 5:{
            title = @"fenxiang_qzone";
            break;
        }
        default:
        break;
    }
    [[self obtainStaticService] sendEventWithType:BPAPPClickEvent param:@{BPWStaticTitleKey:title}];
}

+ (void)showPhotoBrowserWithImageArray:(NSArray *)imageArray imageViewArray:(NSArray *)imageViewArray currentImageIndex:(NSUInteger)currentImageIndex {
    id<BPTWebPhotoBrowserProtocol> service = [[BPBServiceManager sharedManager] createService:@protocol(BPTWebPhotoBrowserProtocol) shouldCache:NO];
    service.imageArray = imageArray;
    service.imageViewArray = imageViewArray;
    service.isReuseImageView = YES;
    service.sourceImagesContainerView = [imageViewArray.firstObject superview];
    service.currentImageIndex = currentImageIndex;
    [service show];
}

+ (void)showWebPhotoBrowserWithImageArray:(NSArray *)imageArray imageViewArray:(NSArray *)imageViewArray currentImageIndex:(NSUInteger)currentImageIndex {
    id<BPTWebPhotoBrowserProtocol> service = [[BPBServiceManager sharedManager] createService:@protocol(BPTWebPhotoBrowserProtocol) shouldCache:NO];
    service.imageArray = imageArray;
    service.imageViewArray = imageViewArray;
    service.currentImageIndex = currentImageIndex;
    service.sourceImagesContainerView = [[imageViewArray BPT_objAtIndex:0] superview];
    [service show];
}
    
+ (void)windowAddsubView:(UIView *)subView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:subView];
}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    NSString *base64String = [UIImageJPEGRepresentation(image,0.5) base64Encoding];
    return base64String;

}

+ (CGFloat )tabbarHeight {
    CGFloat tabbarHeight = [[BPTAppConfig sharedConfig] tabBarPadding] + 49 + kSafeBottomMargin;
    return tabbarHeight;
}

+ (void)adjustmentBehaviorNeverScrollView:(UIScrollView *)scrollView inViewController:(UIViewController *)viewController {
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        viewController.automaticallyAdjustsScrollViewInsets = NO;
    }

}
@end
