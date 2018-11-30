//
//  BPTFMDB.m
//  BPCityManager
//
//  Created by Lazy on 2018/11/28.
//

#import "FDFMDB.h"
#import "FMDB.h"

//#import "NSArray+BPTSafe.h"
//#import "BPTAppMacro.h"
//#import "BPTAddressDBModel.h"

//#define DBFileWithoutExtension @"Address"
//#define DBFileExtension @"sqlite"
#define DBFileWithExtension @"Address.sqlite"


@interface FDFMDB()
@property (nonatomic, strong) FMDatabaseQueue *queue;
//因为可能涉及到数据库的编辑，所以不能放在bundle，需要拷贝到沙盒目录
@property (nonatomic, assign) BOOL shouldUpdateDB;
@property (nonatomic, strong) NSString *DBBundlePath;
@property (nonatomic, strong) NSString *DBSandboxPath;
@property (nonatomic, strong) NSString *DBPath;

@end

@implementation FDFMDB
#pragma mark - public
- (void)updateinTransactionCompleteBlock:(BPTFMDBCompleteBlock)completeBlock excuteBlock:(BPTFMDBCompleteBlock)excuteBlock {
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        @try {
//            [updateModel.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull dicArrray, NSUInteger idx, BOOL * _Nonnull stop) {
//                [dicArrray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idxSecond, BOOL * _Nonnull stop) {
//                    [self _excuteUpdateTable:BPTAddressTableName[idx] addressDic:obj db:db];
//                }];
//            }];
//            updateSql:(NSString *)updateSql, ...
//            if (excuteBlock) {
//                excuteBlock(d);
//            }
            if (excuteBlock) {
                excuteBlock;
            }
            
        } @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}

- (void)executeQueryInQueueWithCompleteBlock:(FDFMDBQueryCompleteBlock)completeBlock
                   querySql:(NSString*)querySql, ... {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:querySql];
        if (completeBlock) {
            completeBlock(resultSet);
        }
        [resultSet close];
    }];
}

#pragma mark - private
//- (BOOL)excuteUpdateBlock:(BPTFMDBExcuteUpdateSqlBlock *)updateBlock {
////    BOOL result = [db executeUpdate:updateSql];
//    updateBlock()
//    return result;
//
//}

- (BOOL)_excuteDB:(FMDatabase *)db updateSql:(NSString *)updateSql, ... {
    BOOL result = [db executeUpdate:updateSql];
    return result;
}

#pragma mark - lazy load

- (FMDatabaseQueue *)queue {
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self DBPath]];
    }
    return _queue;
}

- (NSString *)DBPath{
    if (!_DBPath) {
        _DBPath = self.shouldUpdateDB? self.DBSandboxPath:self.DBBundlePath;
        if (self.shouldUpdateDB) {
            BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.DBSandboxPath];
            if (!isFileExists) {
                NSError *error = nil;
                BOOL copySuccess = [[NSFileManager defaultManager] copyItemAtPath:self.DBBundlePath toPath:self.DBSandboxPath error:&error];
                if (!copySuccess) {
                    NSAssert1(0, @"Failed to create writable resource file with message '%@'.", [error localizedDescription]);
                }
            }
        }
    }
    return _DBPath;
}

- (NSString *)DBSandboxPath {
    if (!_DBSandboxPath) {
        _DBSandboxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:DBFileWithExtension];
    }
    return _DBSandboxPath;
}

- (NSString *)DBBundlePath {
    if (!_DBBundlePath) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BPCityManager" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        _DBBundlePath = [bundle pathForResource:DBFileWithExtension ofType:@""];

    }
    return _DBBundlePath;
}
@end
