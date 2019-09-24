//
//  FDIsInitialDump.h
//  FDKit
//
//  Created by Lazy on 2019/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDIsInitialDump : NSObject

/**
 导出所有runtime注册的类

 @return 类名数组，数组元素都是类名字符串
 */
+ (NSArray<NSString *> *)dumpAllRuntimeRegisteredClasses;

/**
 导出所有（已）经被初始化的runtime注册的类

 @return 类名数组，数组元素都是类名字符串
 */
+ (NSArray<NSString *> *)dumpInitializedClassesInRuntime;

/**
 导出所有（已）经被初始化的runtime注册的类

 @param classArray 待过滤类数组，要求数组元素都是类名字符串
 @return 类名数组，数组元素都是类名字符串
 */
+ (NSArray<NSString *> *)dumpInitializedClassesInArray:(NSArray<NSString *> *)classArray;

/**
 导出所有（未）被初始化的runtime注册的类
 
 @return 类名数组，数组元素都是类名字符串
 */
+ (NSArray<NSString *> *)dumpNotInitializedClassesInRuntime;

/**
 导出所有（未）被初始化的runtime注册的类
 
 @param classArray 待过滤类数组，要求数组元素都是类名字符串
 @return 类名数组，数组元素都是类名字符串
 */
+ (NSArray<NSString *> *)dumpNotInitializedClassesInArray:(NSArray<NSString *> *)classArray;
@end

NS_ASSUME_NONNULL_END
