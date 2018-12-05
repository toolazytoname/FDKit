//
//  FDCRequest.m
//  FatDragonCartoon
//
//  Created by weichao on 16/5/12.
//  Copyright © 2016年 FatDragon. All rights reserved.
//

#import "FDCRequest.h"
@interface FDCRequest()

@end

@implementation FDCRequest
#pragma mark - getter
- (NSString *)URLString {
    if (!_URLString) {
        _URLString = [self FDCRequestGetURLString];
    }
    return _URLString;
}

- (NSDictionary *)httpHeaders {
    if (!_httpHeaders) {
        _httpHeaders = [self FDCRequestHttpHeaders];
    }
    return _httpHeaders;
}

- (bool)isCacheResponse {
    return [self FDCRequestGetIsCacheResponse];
}

- (FDCRequestMethod)method {
    return [self FDCRequestGetMethod];
}

/**
 *  基类默认直接返回responseObject
 *
 */
- (SucessBlock)success {
    if (!_success) {
        SucessBlock sucessBlock = [self FDCRequestGetSuccess];
        _success = [sucessBlock copy];
    }
    return _success;
}

/**
 *  基类默认直接返回responseObject
 */
- (CacheBlock)cache {
    if (!_cache) {
        CacheBlock cacheBlock = [self FDCRequestGetCache];
        _cache = [cacheBlock copy];
    }
    return _cache;
}
/**
 *  基类默认直接返回error
 */
- (FailureBlock)failure {
    if (!_failure) {
        FailureBlock failureBlock = [self FDCRequestGetFailure];
        _failure = [failureBlock copy];
    }
    return _failure;
}


#pragma mark - for inherite
- (NSString *)FDCRequestGetURLString {
    return @"";
}

- (NSDictionary *)FDCRequestHttpHeaders {
    return nil;
}

- (bool)FDCRequestGetIsCacheResponse {
    return YES;
}

- (FDCRequestMethod)FDCRequestGetMethod {
    return FDCRequestGet;
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock success = ^id(NSURLSessionDataTask *task, id responseObject) {
        return responseObject;
    };
    return success;
}

- (CacheBlock)FDCRequestGetCache {
//    CacheBlock cache = ^id(NSURLSessionDataTask *task, id responseObject) {
//        return responseObject;
//    };
//    return cache;
    return [self FDCRequestGetSuccess];

}

- (FailureBlock)FDCRequestGetFailure {
    FailureBlock failure = ^id(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"error:%@",error);
        return error;
    };
    return failure;
}

@end
