//
//  BPTFMDB.m
//  BPCityManager
//
//  Created by Lazy on 2018/11/28.
//

#import "FDFMDB.h"
#import "FMDB.h"
#define DBFileWithExtension @"FDFMDB.sqlite"


@interface FDFMDB()

/**
 To perform queries and updates on multiple threads, you'll want to use this queue
 */
@property (nonatomic, strong) FMDatabaseQueue *queue;

/**
 是否需要编辑数据库
 */
@property (nonatomic, assign) BOOL shouldUpdateDB;

/**
 数据库目录，因为可能涉及到数据库的编辑，所以不能放在bundle，需要拷贝到沙盒目录
 */
@property (nonatomic, strong) NSString *DBPath;

/**
 数据库所在 bundle 目录
 */
@property (nonatomic, strong) NSString *DBBundlePath;

/**
 数据库所在沙盒目录
 */
@property (nonatomic, strong) NSString *DBSandboxPath;

/**
 数据库文件所在bundle
 */
@property (nonatomic, strong) NSBundle *DBBundle;

@end

@implementation FDFMDB
#pragma mark - public
- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldUpdateDB = NO;
    }
    return self;
}

- (instancetype)initWithShouldUpdateDB:(BOOL)shouldUpdateDB {
    self = [self init];
    if (self) {
        _shouldUpdateDB = shouldUpdateDB;
    }
    return self;
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


- (void)updateinTransactionExcuteBlock:(FDFMDBExcuteUpdateSqlBlock)excuteBlock {
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        @try {
            if (excuteBlock) {
                excuteBlock(db,rollback);
            }
        } @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
    
}

- (BOOL)excuteDB:(FMDatabase *)db updateSql:(NSString *)updateSql error:(NSError * __autoreleasing *)error  {
    BOOL result = [db executeUpdate:updateSql values:nil error:error];
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
        _DBPath = self.shouldUpdateDB?self.DBSandboxPath:self.DBBundlePath;
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
        NSBundle *bundle = [NSBundle mainBundle];
        if (_DBBundle) {
            bundle = _DBBundle;
        }
        _DBBundlePath = [bundle pathForResource:DBFileWithExtension ofType:@""];
        NSLog(@"DBBundlePath:%@",_DBBundlePath);
    }
    return _DBBundlePath;
}
@end
