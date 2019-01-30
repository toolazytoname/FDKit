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
        [self log:aspectInfo];
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
        [self log:aspectInfo];
        // Call original implementation.
        BOOL isPointInside;
        NSInvocation *invocation = aspectInfo.originalInvocation;
        [invocation invoke];
        [invocation getReturnValue:&isPointInside];
        if (isPointInside) {
            if([NSStringFromClass(UIWindow.class) isEqualToString: NSStringFromClass([aspectInfo.instance class])]){
                pointInsideChain = [[NSMutableString alloc] initWithFormat:@"%@ %p",NSStringFromClass([aspectInfo.instance class]),aspectInfo.instance];
            }
            else {
                [pointInsideChain appendFormat:@" => %@ %p",NSStringFromClass([aspectInfo.instance class]),aspectInfo.instance];
            }
        }
    } error:NULL];
    
    [UIResponder aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIResponder aspect_hookSelector:@selector(touchesMoved:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIResponder aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIResponder aspect_hookSelector:@selector(touchesCancelled:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    
    
    
    [UIGestureRecognizer aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIGestureRecognizer aspect_hookSelector:@selector(touchesMoved:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIGestureRecognizer aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIGestureRecognizer aspect_hookSelector:@selector(touchesCancelled:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    
    
    [UIControl aspect_hookSelector:@selector(beginTrackingWithTouch:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UITouch *touch, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIControl aspect_hookSelector:@selector(continueTrackingWithTouch:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UITouch *touch, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIControl aspect_hookSelector:@selector(endTrackingWithTouch:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UITouch *touch, UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    [UIControl aspect_hookSelector:@selector(cancelTrackingWithEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UIEvent *event) {
        [self log:aspectInfo];
    } error:NULL];
    
    
    [UIApplication aspect_hookSelector:@selector(sendEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UIEvent *event) {
        [self log:aspectInfo];
        UITouch *touch = [event.allTouches anyObject];
        NSLog(@"UIApplication sendEvent:%@,%@", touch.window,touch.view);
    } error:NULL];
    
    [UIWindow aspect_hookSelector:@selector(sendEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UIEvent *event) {
        UITouch *touch = [event.allTouches anyObject];
        NSLog(@"UIWindow sendEvent:%@,%@", touch.window,touch.view);
    } error:NULL];
}

+ (void)log:(id<AspectInfo>)aspectInfo {
    NSLog(@"class:%@;selector:%@;address:%p",NSStringFromClass([aspectInfo.instance class]),NSStringFromSelector(aspectInfo.originalInvocation.selector),aspectInfo.instance);
}
@end
