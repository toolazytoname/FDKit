//
//  NSNumber+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/8/24.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSNumber+FDAdd.h"
#import "NSString+FDAdd.h"
#import "FDCategoriesMacro.h"

FDSYNTH_DUMMY_CLASS(NSNumber_FDAdd)


@implementation NSNumber (FDAdd)

+ (NSNumber *)fd_numberWithString:(NSString *)string {
    NSString *str = [[string fd_stringByTrim] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    NSNumber *num = dic[str];
    if (num != nil) {
        if (num == (id)[NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

+ (NSUInteger)fd_RandomTo:(NSUInteger)to {
    NSUInteger random = arc4random() % to;
    return random;
}

+ (NSUInteger)fd_RandomFrom:(NSUInteger)from to:(NSUInteger)to {
    NSUInteger random = (arc4random() % (from + 1)) + to - from;
    return random;
}

//-(NSUInteger)getRandomNumber:(NSUInteger)from to:(NSUInteger)to {
//    return (int)(from + (arc4random() % (to – from + 1)));
//}

@end
