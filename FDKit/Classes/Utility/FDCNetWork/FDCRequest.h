//
//  FDCRequest.h
//  FatDragonCartoon
//
//  Created by weichao on 16/5/12.
//  Copyright © 2016年 FatDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, FDCRequestMethod)
{
    FDCRequestGet,
    FDCRequestPost,
};
typedef id (^SucessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef id (^CacheBlock)(NSURLSessionDataTask *task, id responseObject);
typedef id (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface FDCRequest : NSObject
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, copy) NSDictionary *httpHeaders;
@property (nonatomic, assign) FDCRequestMethod method;
/**
 *  是否试着让缓存返回Response，如果当前request有缓存，会返回Response；如果木有，则不会返回。
 */
@property (nonatomic, assign) bool isCacheResponse;
@property (nonatomic, copy) SucessBlock success;
@property (nonatomic, copy) CacheBlock cache;
@property (nonatomic, copy) FailureBlock failure;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

#pragma mark - for inherite
- (NSString *)FDCRequestGetURLString;
- (NSDictionary *)FDCRequestHttpHeaders;
- (bool)FDCRequestGetIsCacheResponse;
- (FDCRequestMethod)FDCRequestGetMethod;
- (SucessBlock)FDCRequestGetSuccess;
- (CacheBlock)FDCRequestGetCache;
- (FailureBlock)FDCRequestGetFailure;
@end
