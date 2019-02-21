//
//  NSNumber+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/8/24.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (FDAdd)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)fd_numberWithString:(NSString *)string;


/**
 获取一个随机整数范围在：[0,to)包括0，不包括to

 @return 随机数
 */
+ (NSUInteger)fd_RandomTo:(NSUInteger)to;


/**
 获取一个随机数范围在：[from,to），包括from，不包括to

 @param from 最小值
 @param to 最大值
 @return 随机数
 */
+ (NSUInteger)fd_RandomFrom:(NSUInteger)from to:(NSUInteger)to;

+ (NSString *)fd_randomWithLength:(NSUInteger)length;
@end

NS_ASSUME_NONNULL_END
