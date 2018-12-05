//
//  FDCSessionManager.m
//  FatDragonCartoon
//
//  Created by weichao on 16/5/12.
//  Copyright © 2016年 FatDragon. All rights reserved.
//

#import "FDCSessionManager.h"
#import "FDCRequest.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "FDCNetworkCache.h"


@interface FDCSessionManager()

@end

@implementation FDCSessionManager
+ (instancetype)sharedManager {
    static FDCSessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FDCSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://mobilev3.ac.qq.com/"]];
        sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        sharedManager.completionQueue = dispatch_queue_create([FDCCacheResponseQueueLabel cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    return sharedManager;
}

- (void)cancelAllRequest {
    [self invalidateSessionCancelingTasks:YES];
}

- (void)cancelRequestWithRequest:(FDCRequest *)request {
    [request.dataTask cancel];
}


- (NSURLSessionDataTask *)request:(FDCRequest *)request
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            cache:(void (^)(NSURLSessionDataTask *task, id responseObject))cache
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSURLSessionDataTask *task = nil;
    NSString *URLString = request.URLString;
    NSDictionary *parameters = request.parameters;
    [request.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (key&&obj) {
            [self.requestSerializer setValue:obj forHTTPHeaderField:key];
        }
    }];
    
    switch (request.method) {
        case FDCRequestGet: {
            task = [[FDCSessionManager sharedManager] GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self sucessCallbackWithTask:task responseObject:responseObject request:request success:success cache:cache failure:failure];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failureCallbackWithTask:task error:error request:request success:success cache:cache failure:failure];
            }];
            break;
        }
        case FDCRequestPost: {
            task = [[FDCSessionManager sharedManager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self sucessCallbackWithTask:task responseObject:responseObject request:request success:success cache:cache failure:failure];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failureCallbackWithTask:task error:error request:request success:success cache:cache failure:failure];
            }];
            break;
        }
        default:
            break;
    }
    if (request.isCacheResponse) {
        dispatch_async(self.completionQueue, ^{
            @try {
                //cache 返回
                id responseObject = [[FDCNetworkCache sharedCache] httpCacheForURL:URLString parameters:parameters];
                if ( responseObject) {
                    //主线程执行
                    //如果cache 和request.cache 都为有效值，则request.cache先处理，处理结果交由外部传入的cache继续处理
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cache(task,request.cache(task,responseObject));
                    });
                }
            } @catch (NSException *exception) {
                NSLog(@"exception:%@",exception);
            }
        });
    }
//    NSLog(@"weichaotest_task.originalRequest.URL:%@",task.originalRequest.URL);
    return task;
}

- (void)sucessCallbackWithTask:(NSURLSessionDataTask *)task
                responseObject:(id)responseObject
                       request:(FDCRequest *)request
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         cache:(void (^)(NSURLSessionDataTask *task, id responseObject))cache
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    @try {
        if (request.isCacheResponse&&responseObject) {
            [[FDCNetworkCache sharedCache] setHttpCache:responseObject URL:request.URLString parameters:request.parameters];
        }
        //如果sucess 和request.success 都为有效值，则request.success先处理，处理结果交由外部传入的success继续处理
        if (success&&request.success) {
            id requestResponseObject = request.success(task,responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(task,requestResponseObject);
            });
        }

    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    
}

- (void)failureCallbackWithTask:(NSURLSessionDataTask *)task
                          error:(NSError *) error
                        request:(FDCRequest *)request
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          cache:(void (^)(NSURLSessionDataTask *task, id responseObject))cache
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    if (failure&&request.failure) {
        id requestResponseObject = request.failure(task,error);
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(task,requestResponseObject);
        });
    }
}
@end
