//
//  BPWBaseCollectionViewDelegate.h
//  FDKit
//
//  Created by Lazy on 2018/8/14.
//

#import <Foundation/Foundation.h>

@interface FDBaseCollectionViewDelegate : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cellClassArray;
@property (nonatomic, strong) NSArray *supplementaryViewClassArray;
@property (nonatomic, strong) NSArray *supplementaryViewNibClassArray;
@property (nonatomic, strong) NSDictionary *modelToCellClassMap;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
- (void)refreshData:(id)model;
@end
