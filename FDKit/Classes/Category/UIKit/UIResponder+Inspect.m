//
//  UIResponder+Inspect.m
//  FDKit
//
//  Created by Lazy on 2019/1/30.
//

#import "UIResponder+Inspect.h"

@implementation UIResponder (Inspect)
+ (NSString *)responderChainWithResponder:(UIResponder *)firstResponder
{
    UIResponder *responder = firstResponder;
    NSMutableString *responderChain = [NSMutableString stringWithFormat:@"%@ %p",responder.class,responder];
    while ((responder = [responder nextResponder])) {
        [responderChain appendFormat:@" => %@ %p",responder.class,responder];
    }
    return responderChain;
}

@end
