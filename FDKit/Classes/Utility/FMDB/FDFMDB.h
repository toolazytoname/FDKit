//
//  BPTFMDB.h
//  BPCityManager
//
//  Created by Lazy on 2018/11/28.
//

#import <Foundation/Foundation.h>
@class FMResultSet;
@class FMDatabase;

NS_ASSUME_NONNULL_BEGIN
//查询结果返回resultSet
typedef void(^FDFMDBQueryCompleteBlock)(FMResultSet *resultSet);


//
typedef void(^FDFMDBExcuteUpdateSqlBlock)(FMDatabase *db ,NSString *updateSql, ...);

//
typedef void(^BPTFMDBCompleteBlock)(id data);


@interface FDFMDB : NSObject

/**
 初始化实例

 @param shouldUpdateDB 是否需要更新数据库
 @return FDFMDB instance
 */
- (instancetype)initWithShouldUpdateDB:(BOOL)shouldUpdateDB;


/**
 查询操作

 @param completeBlock 查询结果回调
 @param querySql 查询sql语句
 */
- (void)executeQueryInQueueWithCompleteBlock:(FDFMDBQueryCompleteBlock)completeBlock
                                    querySql:(NSString*)querySql, ...;
@end

NS_ASSUME_NONNULL_END
