//
//  FDOperation.m
//  FDKit
//
//  Created by Lazy on 2019/1/2.
//

#import "FDOperation.h"
#import "FDCategoriesMacro.h"

#define  willExecut [self willChangeValueForKey:@"isExecuting"];
#define  didExecut [self didChangeValueForKey:@"isExecuting"];

#define willFinish [self willChangeValueForKey:@"isFinished"];
#define didFinish [self didChangeValueForKey:@"isFinished"];

@interface FDOperation()
@property (nonatomic, strong) id fd_model;
@end

@implementation FDOperation
// @synthesize 关键字手动合成了两个实例变量 _executing 和 _finished ，然后分别在重写的 isExecuting 和 isFinished 方法中返回了这两个实例变量。另外，我们通过查看 NSOperation 类的头文件可以发现，executing 和 finished 属性都被声明成了只读的 readonly 。所以我们在 NSOperation 子类中就没有办法直接通过 setter 方法来自动触发 KVO 通知，这也是为什么我们需要在接下来的代码中手动触发 KVO 通知的原因。
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
        }
    }
    return self;
}

- (void)start {
    if (self.isCancelled) {
        [self fd_cancel];
        return;
    }
    [self main];
}

//通常这个方法就是专门用来实现与该 operation 相关联的任务的。尽管我们可以直接在 start 方法中执行我们的任务，但是用 main 方法来实现我们的任务可以使设置代码和任务代码得到分离，从而使 operation 的结构更清晰；
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
    [self fd_finish];
}

- (void)fd_work {
    [self fd_finish];
}

#pragma mark - kov change method
- (void)fd_finish {
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
