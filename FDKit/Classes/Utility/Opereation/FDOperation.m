//
//  FDOperation.m
//  FDKit
//
//  Created by Lazy on 2019/1/2.
//

#import "FDOperation.h"
#import "FDCategoriesMacro.h"
#import "NSObject+FDAddForKVO.h"


#define  willExecut [self willChangeValueForKey:@"isExecuting"];
#define  didExecut [self didChangeValueForKey:@"isExecuting"];

#define willFinish [self willChangeValueForKey:@"isFinished"];
#define didFinish [self didChangeValueForKey:@"isFinished"];

@interface FDOperation()
@property (nonatomic, strong) id fd_model;
@property (nonatomic, copy) FDOperationFinishBlock fd_finishBlock;
@end

@implementation FDOperation
@synthesize executing = _executing;
@synthesize finished  = _finished;
#pragma mark -life cycle
- (instancetype)initWithModel:(id)model {
    self =  [super init];
    if (self) {
        [self fd_changeExecuting_NO];
        [self fd_chageFinished_NO];
        if (model) {
            self.fd_model = model;
            @weakify(self)
            [self fd_addObserverBlockForKeyPath:@"isCancelled" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                @strongify(self)
                if ([newVal isEqual: @(YES)]) {
                    [self fd_cancel];
                }
            }];
            self.fd_finishBlock = ^{
                @strongify(self)
                [self fd_finish];
            };

        }
    }
    return self;
}

- (void)dealloc {
    [self fd_removeObserverBlocks];
}

- (void)start {
    if (self.isCancelled) {
        [self fd_finish];
        return;
    }
    [self main];
}

- (void)main {
    @try {
        [self fd_changeExecuting_YES];
        [self fd_work];
    } @catch (NSException *exception) {
        [self fd_finish];
    }
}

#pragma mark - public method
- (void)fd_cancel {
    self.fd_finishBlock;
}

- (void)fd_work {
}

#pragma mark - kov change method
- (void)fd_finish {
    [self fd_removeObserverBlocks];
    [self fd_changeExecuting_NO];
    [self fd_chageFinished_YES];
}

- (void)fd_changeExecuting_YES {
    willExecut
    _executing = YES;
    didExecut
}

- (void)fd_changeExecuting_NO {
    willExecut
    _executing = NO;
    didExecut
}

- (void)fd_chageFinished_YES {
    willFinish
    _finished = YES;
    didFinish
}

- (void)fd_chageFinished_NO {
    willFinish
    _finished = NO;
    didFinish
}

#pragma mark - getter
- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}
@end
