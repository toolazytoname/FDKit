//
//  BPWBaseCollectionViewDelegate.m
//  AFNetworking
//
//  Created by Lazy on 2018/8/14.
//

#import "FDBaseCollectionViewDelegate.h"
#import "FDCollectionViewCellProtocol.h"

#import "FDCategoriesMacro.h"
#import "NSArray+FDAdd.h"

@implementation FDBaseCollectionViewDelegate

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self registerViews];
    }
    return self;
}

- (void)registerViews {
    @weakify(self)
    [self.cellClassArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [self.collectionView registerNib:FDNibWithClassName(NSStringFromClass(obj)) forCellWithReuseIdentifier:FDIdentifierWithViewName(NSStringFromClass(obj))];
    }];
    [self.supplementaryViewNibClassArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [self.collectionView registerNib:FDNibWithClassName(NSStringFromClass(obj)) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FDIdentifierWithViewName(NSStringFromClass(obj))];
    }];
    [self.supplementaryViewClassArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)        
        [self.collectionView registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FDIdentifierWithViewName(NSStringFromClass(obj))];
        
    }];
}

- (void)refreshData:(id)model {
    self.dataArray = (NSMutableArray *)model;
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[self.dataArray fd_objectOrNilAtIndex:section] count];
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [[self.dataArray fd_objectOrNilAtIndex:indexPath.section] fd_objectOrNilAtIndex:indexPath.row];
    Class cellClass = [self.modelToCellClassMap valueForKey: NSStringFromClass([model class])];
    NSString *identifier = FDIdentifierWithViewName(NSStringFromClass(cellClass));
    UICollectionViewCell<FDDataViewProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setViewWithModel:model];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headview = [[UICollectionReusableView alloc] init];
    return headview;
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [[self.dataArray fd_objectOrNilAtIndex:indexPath.section] fd_objectOrNilAtIndex:indexPath.row];
    Class cellClass = [self.modelToCellClassMap valueForKey: NSStringFromClass([model class])];
    return [cellClass collectionViewCellSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeZero;
    return headerSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

#pragma mark -
#pragma mark - UICollectionView Deleage

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select indexPath:%@",indexPath);
}



@end
