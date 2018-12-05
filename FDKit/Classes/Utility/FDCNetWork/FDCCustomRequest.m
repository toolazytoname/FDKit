//
//  FDCCustomRequest.m
//  FatDragonCartoon
//
//  Created by weichao on 16/5/12.
//  Copyright © 2016年 FatDragon. All rights reserved.
//

#import "FDCCustomRequest.h"
#import "FDCModels.h"
#import "FDCSourceConfigParser.h"
#import "YYModel.h"
#import "NSString+FDCAdd.h"
#import "FDCSearchBookModel.h"

@implementation FDCCustomRequest

@end

@implementation FDCHotBookListRequest
- (NSString *)FDCRequestGetURLString {
    return  [[FDCSourceConfigParser sharedParser] hotListURL];
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock sucess = ^id(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSArray *dataArray = [(NSDictionary *)responseObject valueForKeyPath:[[FDCSourceConfigParser sharedParser] hotListDataPath]];
        NSError *error = nil;
        NSArray *bookArray = [NSArray yy_modelArrayWithClass:FDCBookModel.class json:dataArray ];
        return bookArray;
       
    };
    return sucess;
}

- (CacheBlock)FDCRequestGetCache {
    return [self FDCRequestGetSuccess];
}

- (NSDictionary *)FDCRequestHttpHeaders {
    return [[FDCSourceConfigParser sharedParser] currentHeadersForWebPage];
}

@end

@implementation FDCUpdateBookListRequest

@end


@implementation FDCCategoryBookListRequest

- (BOOL)FDCRequestGetIsCacheResponse {
    return YES;
}

- (NSString *)FDCRequestGetURLString {
    NSString *format = [self.bookCategory.url stringByReplacingOccurrencesOfString:@"@" withString:@"%@"];
    NSString *url = [NSString stringWithFormat:format,self.curIndex];
    return url;
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock sucess = ^id(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *dataArray = [responseObject valueForKeyPath:[[FDCSourceConfigParser sharedParser]  classDataArrayKeyPath] ];
        NSArray *bookArray = [NSArray yy_modelArrayWithClass:FDCBookModel.class json:dataArray ];
        NSString *endString = [responseObject valueForKeyPath:[[FDCSourceConfigParser sharedParser] nexPageKeyPath]];
        if (bookArray && endString) {
            return @{@"bookArray":bookArray,
                     @"endString":endString
                     };
        }
        return nil;
    };
    return sucess;
}

- (NSDictionary *)FDCRequestHttpHeaders {
    return [[FDCSourceConfigParser sharedParser] currentHeadersForWebPage];
}

- (CacheBlock)FDCRequestGetCache {
    return [self FDCRequestGetSuccess];
}


@end


@implementation FDCChapterListRequest
- (BOOL)FDCRequestGetIsCacheResponse {
    return YES;
}

- (NSString *)FDCRequestGetURLString {
    return [[[FDCSourceConfigParser sharedParser] chapterinfoURL] stringByReplacingOccurrencesOfString:@"@" withString:self.bookModel.comicUrlKey];
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock sucess = ^id(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *dataArray = [responseDictionary valueForKeyPath: [[FDCSourceConfigParser sharedParser] chapterDataArrayKeyPath]];
        NSArray *chapterModelArray = [NSArray yy_modelArrayWithClass:FDCChapterModel.class json:dataArray];
        [chapterModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FDCChapterModel *chapterModel = (FDCChapterModel *)obj;
            chapterModel.fdcBookID = self.bookModel.fdcBookID;
        }];
        return chapterModelArray;
        
    };
    return sucess;
}

- (NSDictionary *)FDCRequestHttpHeaders {
    return [[FDCSourceConfigParser sharedParser] currentHeadersForWebPage];
}

- (CacheBlock)FDCRequestGetCache {
    return [self FDCRequestGetSuccess];
}
@end

@implementation FDCComicDetailRequest
- (NSString *)FDCRequestGetURLString {
    return [[[FDCSourceConfigParser sharedParser] bookInfoURL] stringByReplacingOccurrencesOfString:@"#" withString:self.bookModel.comicUrlKey];
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock sucess = ^id(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error = nil;
        NSDictionary *dic = [responseDictionary valueForKeyPath: [[FDCSourceConfigParser sharedParser] bookDataKeyPath]];

        FDCBookModel *bookModel = [FDCBookModel yy_modelWithJSON:dic];
        if (error) {
            NSLog(@"error:%@",error);
            return nil;
        }
        return bookModel;
        
    };
    return sucess;
}

- (NSDictionary *)FDCRequestHttpHeaders {
    return [[FDCSourceConfigParser sharedParser] currentHeadersForWebPage];
}


@end


@implementation FDCImageListRequest

- (NSString *)FDCRequestGetURLString {
    return [[[FDCSourceConfigParser sharedParser] chapterDetailURL] stringByReplacingOccurrencesOfString:@"@" withString:self.chapterModel.subListUrlKey];
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock sucess = ^id(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSArray *dataArray = [(NSDictionary *)responseObject valueForKeyPath:[[FDCSourceConfigParser sharedParser] bookDataKeyPath]];
        NSArray *imageModelArray = [NSArray yy_modelArrayWithClass:FDCImageModel.class json:dataArray];
        //批量设置，kvc 真帅
        [imageModelArray setValue:self.chapterModel.fdcBookID forKey:NSStringFromSelector(@selector(fdcBookID))];
        [imageModelArray setValue:self.chapterModel.fdcChapterID forKey:NSStringFromSelector(@selector(fdcChapterID))];
        return imageModelArray;
    };
    return sucess;
}

@end


@implementation FDCSearchRequest
- (NSString *)FDCRequestGetURLString {
    NSString *serverURLFormat = [[FDCSourceConfigParser sharedParser] searchURLWithIndex:self.serverIndex];
    NSString *keyWorkd = [[self.keyword fdc_trim] fdc_encodedUTF8String];
    return [serverURLFormat stringByReplacingOccurrencesOfString:@"@" withString:keyWorkd];
}

- (SucessBlock)FDCRequestGetSuccess {
    SucessBlock sucess = ^id(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSArray *dataArray = [(NSDictionary *)responseObject valueForKeyPath:[[FDCSourceConfigParser sharedParser] searchDataArrayKeyPathWithIndex:self.serverIndex]];
        [FDCSearchBookModel changeServerIndex:self.serverIndex];
        NSArray *bookModelArray = [NSArray yy_modelArrayWithClass:FDCSearchBookModel.class json:dataArray];
        return bookModelArray;
    };
    return sucess;
}


@end
