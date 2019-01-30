//
//  FDHitTestInspect.m
//  FDKit
//
//  Created by Lazy on 2019/1/30.
//

#import "FDHitTestInspect.h"
#import "Aspects.h"
#import "UIResponder+Inspect.h"


@implementation FDHitTestInspect
+ (void)inspect {
    __block NSMutableString *pointInsideChain;
    [UIView aspect_hookSelector:@selector(hitTest:withEvent:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo, CGPoint point ,UIEvent *event) {
        NSLog(@"hitTest %@", aspectInfo.instance);
        UIView * __unsafe_unretained hitTestView;
        NSInvocation *invocation = aspectInfo.originalInvocation;
        [invocation invoke];
        [invocation getReturnValue:&hitTestView];
        UIView *result = hitTestView;
        if (result == aspectInfo.instance) {
            NSLog(@"[FDResponder Chain]:%@",[UIResponder responderChainWithResponder:aspectInfo.instance]) ;
            NSLog(@"[FDPointInside Chain]:%@",pointInsideChain) ;
        }
    } error:NULL];
    [UIView aspect_hookSelector:@selector(pointInside:withEvent:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo, CGPoint point ,UIEvent *event) {
        NSLog(@"pointInside %@", aspectInfo.instance);
        // Call original implementation.
        BOOL isPointInside;
        NSInvocation *invocation = aspectInfo.originalInvocation;
        [invocation invoke];
        [invocation getReturnValue:&isPointInside];
        if (isPointInside) {
            if([NSStringFromClass(UIWindow.class) isEqualToString: NSStringFromClass([aspectInfo.instance class])]){
                pointInsideChain = [[NSMutableString alloc] initWithFormat:@"%@ %p",NSStringFromClass(self.class),self];
            }
            else {
                [pointInsideChain appendFormat:@" => %@ %p",NSStringFromClass(self.class),self];
            }
        }
    } error:NULL];
}
@end
