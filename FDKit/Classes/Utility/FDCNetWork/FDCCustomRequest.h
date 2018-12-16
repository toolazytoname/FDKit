//
//  FDCCustomRequest.h
//  FatDragonCartoon
//
//  Created by weichao on 16/5/12.
//  Copyright © 2016年 FatDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDCRequest.h"


@interface FDCCustomRequest : NSObject

@end

///**
// *  热门图书列表
// */
//@interface FDCHotBookListRequest : FDCRequest
//
//@end
//
///**
// *  最新更新
// 没有分页
// 
// */
//@interface FDCUpdateBookListRequest : FDCRequest
//
//@end
//
///**
// *  某一分类的图书列表
// *
// */
//@interface FDCCategoryBookListRequest : FDCRequest
//
//@property (nonatomic, strong) FDCClasses *bookCategory;
//@property(nonatomic,strong) NSString *curIndex;
//
//@end
//
//
///**
// *  某一个漫画的章节列表
// */
//@interface FDCChapterListRequest : FDCRequest
//@property (nonatomic, strong) FDCBookModel *bookModel;
//@end
//
///**
// *  漫画详情
// */
//@interface FDCComicDetailRequest : FDCRequest
//@property (nonatomic, strong) FDCBookModel *bookModel;
//
//@end
//
//
///**
// *  某一章图片列表
// */
//@interface FDCImageListRequest : FDCRequest
//@property (nonatomic, strong) FDCChapterModel *chapterModel;
//@end
//
//
///**
// *  搜索
// */
//@interface FDCSearchRequest : FDCRequest
//@property (nonatomic, strong) NSString *keyword;
//@property (nonatomic, assign) NSUInteger serverIndex;
//@end


