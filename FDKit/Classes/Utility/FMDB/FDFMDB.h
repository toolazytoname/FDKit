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
/**
 查询结果返回resultSet

 @param resultSet 查询结果返回resultSet
 */
typedef void(^FDFMDBQueryCompleteBlock)(FMResultSet *resultSet);



/**
 事务上的执行方法

 @param db db
 @param rollback 是否回滚
 */
typedef void(^FDFMDBExcuteUpdateSqlBlock)(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback);


@interface FDFMDB : NSObject

/**
 初始化实例

 @param shouldUpdateDB 是否需要更新数据库
 @return FDFMDB instance
 */
- (instancetype)initWithShouldUpdateDB:(BOOL)shouldUpdateDB;


/**
 查询操作

 @param completeBlock 查询结果回调 FMResultSet *resultSet
 @param querySql 查询sql语句
 */
- (void)executeQueryInQueueWithCompleteBlock:(FDFMDBQueryCompleteBlock)completeBlock
                                    querySql:(NSString*)querySql, ...;

/**
 在一个事务上更新数据库

 @param excuteBlock 封装好sql语句有，调用- (BOOL)excuteDB:(FMDatabase *)db updateSql:(NSString *)updateSql error:(NSError * __autoreleasing *)error方法
 */
- (void)updateinTransactionExcuteBlock:(FDFMDBExcuteUpdateSqlBlock)excuteBlock;


/**
 Execute single update statement

 @param db db
 @param error A `NSError` object to receive any error object (if any).
 @param updateSql The SQL to be performed, with optional `?` placeholders.
 @return 是否成功
 */
- (BOOL)excuteDB:(FMDatabase *)db error:(NSError * __autoreleasing *)error updateSql:(NSString *)updateSql, ...;
@end

NS_ASSUME_NONNULL_END
