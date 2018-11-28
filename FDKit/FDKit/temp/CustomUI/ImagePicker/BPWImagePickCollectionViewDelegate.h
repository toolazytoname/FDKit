//
//  BPWImagePickCollectionViewDelegate.h
//  AFNetworking
//
//  Created by Yiche on 2018/8/30.
//

#import "BPWBaseCollectionViewDelegate.h"

@interface BPWImagePickCollectionViewDelegate : BPWBaseCollectionViewDelegate
@property(nonatomic, assign) NSUInteger maxPickCount;


- (void)addImageArray:(NSArray *)imageArray;
- (void)removeAt:(NSUInteger)index;
@end
