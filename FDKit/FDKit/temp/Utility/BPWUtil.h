//
//  BPWUtil.h
//  AFNetworking
//
//  Created by Yiche on 2018/8/7.
//

#import <Foundation/Foundation.h>
#import "BPLProtocol.h"
#import "BPPMainProtocol.h"
#import "BPTSchemaProtocol.h"
#import "BPBStatisticProtocol.h"

@class BPEResponseModel;

@interface BPWUtil : NSObject
+ (NSBundle *)currentBundle;

+ (UIImage *)imageInBundleWithName:(NSString *)imageName;

+ (UIImage *)sucessImage;

+ (UIImage *)noDataImage;

+ (UINib *)nibInBundleWithName:(NSString *)nibName;

+ (NSString *)identifierWithViewName:(NSString *)viewName;

+ (BOOL)isNull:(id)object;

+ (BOOL)handleError:(BPEResponseModel *)model;

+ (BPLForumUser *)sharedForumUser;
+ (id<BPLProtocol>)obtainBPLService;

+ (id<BPPMainProtocol>)obtainBPPService;

+ (id<BPTSchemaProtocol>)obtainSchemaService;

+ (id<BPBStatisticProtocol>)obtainStaticService;
    
+ (void)staticWithParameter:(NSDictionary *)parameter;
    
+ (void)staticWithShareInteger:(NSUInteger)index;

+ (void)showPhotoBrowserWithImageArray:(NSArray *)imageArray imageViewArray:(NSArray *)imageViewArray currentImageIndex:(NSUInteger)currentImageIndex;

+ (void)showWebPhotoBrowserWithImageArray:(NSArray *)imageArray imageViewArray:(NSArray *)imageViewArray currentImageIndex:(NSUInteger)currentImageIndex;
    
+ (void)windowAddsubView:(UIView *)subView;

+ (NSString *)encodeToBase64String:(UIImage *)image;

+ (CGFloat )tabbarHeight;

+ (void)adjustmentBehaviorNeverScrollView:(UIScrollView *)scrollView inViewController:(UIViewController *)viewController;

@end
