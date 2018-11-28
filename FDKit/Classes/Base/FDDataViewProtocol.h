//
//  FDDataViewProtocol.h
//  FDKit
//
//  Created by lazy on 2018/8/7.
//

#import <Foundation/Foundation.h>

static inline NSString *FDIdentifierWithViewName(NSString * viewName) {
    if (!viewName || viewName.length == 0) {
        return nil;
    }
    return [viewName stringByAppendingString:@"Identifier"];
}

static inline UINib *FDNibWithClassName(NSString *nibName) {
    if (!nibName || nibName.length == 0) {
        return nil;
    }
    NSBundle *resourceBundle = [NSBundle bundleForClass:NSClassFromString(nibName)];
    UINib *nib = [UINib nibWithNibName:nibName bundle:resourceBundle];
    return nib;
}

@protocol FDDataViewProtocol <NSObject>
- (void)setViewWithModel:(id)model;
@end
