//
//  BPWImagePickNetworkDelegate.h
//  AFNetworking
//
//  Created by Yiche on 2018/8/31.
//

#import <Foundation/Foundation.h>
typedef void(^BPWFailureBlock)(void);
typedef void(^BPWSucessBlock)(id data);

@interface BPWImagePickNetworkDelegate : NSObject

- (void)uploadImage:(UIImage *)image sucessBlock:(BPWSucessBlock)sucessBlock failureBlock:(BPWFailureBlock)failureBlock;
@end
