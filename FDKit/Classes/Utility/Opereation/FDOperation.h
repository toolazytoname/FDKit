//
//  FDOperation.h
//  FDKit
//
//  Created by Lazy on 2019/1/2.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^FDOperationFinishBlock)(void);

@protocol FDOperationProtocol <NSObject>
@required
/**
 调用结束以后执行调用 [super fd_work];设置kvo状态
 例如
 - (void)fd_work {
    [BPERequestManager startRequest:self.preRequest.request completion:^(BPEResponseModel *model) {
        if (self.isCancelled) {
            [self fd_cancel];
            return;
        }
        dispatch_async_on_main_queue(^{
            if(self.preRequest.responseBlock) {
            self.preRequest.responseBlock(model);
            [super fd_work];
            }
        });
    }];
 }
 */
- (void)fd_work;
@optional
/**
 调用结束以后执行fd_finishBlock设置kvo状态,在最后调用[super fd_cancel];
 例如：
 - (void)fd_cancel {
    if (self.preRequest.request) {
        [self.preRequest.request stop];
    }
    [super fd_cancel];
 }
 */
- (void)fd_cancel;
@end

/**
 集成FDOperation这个类，遵循FDOperationProtocol 这个协议，就可以简单实现一个NSOperation的子类化。
 */
@interface FDOperation : NSOperation<FDOperationProtocol>
@property (nonatomic, strong, readonly) id fd_model;
- (instancetype)initWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
