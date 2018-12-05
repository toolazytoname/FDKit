//
//  FDCSessionManager.h
//  FatDragonCartoon
//
//  Created by weichao on 16/5/12.
//  Copyright © 2016年 FatDragon. All rights reserved.
//


#import <AFNetworking/AFNetworking.h>
@class FDCRequest;
@interface FDCSessionManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

- (void)cancelAllRequest;

- (void)cancelRequestWithRequest:(FDCRequest *)request;

- (NSURLSessionDataTask *)request:(FDCRequest *)request
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            cache:(void (^)(NSURLSessionDataTask *task, id responseObject))cache
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



@end
