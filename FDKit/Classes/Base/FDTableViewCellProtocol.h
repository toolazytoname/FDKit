//
//  FDTableViewCellProtocol.h
//  FDKit
//
//  Created by weichao on 2018/11/22.
//

#import <Foundation/Foundation.h>
#import "FDDataViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FDTableViewCellProtocol <FDDataViewProtocol>
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
