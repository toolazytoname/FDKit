//
//  BPWImagePickNetworkDelegate.m
//  AFNetworking
//
//  Created by Yiche on 2018/8/31.
//

#import "BPWImagePickNetworkDelegate.h"
#import "BPWWebEngine+order.h"
#import "BPWUtil.h"

@implementation BPWImagePickNetworkDelegate
- (void)uploadImage:(UIImage *)image sucessBlock:(BPWSucessBlock)sucessBlock failureBlock:(BPWFailureBlock)failureBlock {
    [[BPWWebEngine sharedWebEngine] uploadImageWithBase64Str:[BPWUtil encodeToBase64String:image] width:@(image.size.height*image.scale) height:@(image.size.width*image.scale) completionBlock:^(BPEResponseModel *model) {
        if ([BPWUtil handleError:model]) {
            if(failureBlock){
                failureBlock();
            }
            return;
        }
        NSString *imageUrl = model.responseData;
        sucessBlock(imageUrl);
    }];
}
@end
