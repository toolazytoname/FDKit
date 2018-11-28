//
//  BPWImagePickCollectionViewDelegate.m
//  AFNetworking
//
//  Created by Yiche on 2018/8/30.
//

#import "BPWImagePickCollectionViewDelegate.h"
#import "NSArray+BPTSafe.h"
#import "BPWImageCell.h"
#import "BPWPlaceHolder.h"
#import "BPWUtil.h"
#import "UIView+BPTAdditions.h"
#import "BPWImagePickerViewController.h"
#import "NSMutableArray+BPWAddition.h"
#import "BPBServiceManager.h"

@implementation BPWImagePickCollectionViewDelegate
@synthesize cellClassArray = _cellClassArray;
@synthesize supplementaryViewNibClassArray = _supplementaryViewNibClassArray;
@synthesize modelToCellClassMap = _modelToCellClassMap;
@synthesize dataArray = _dataArray;

- (void)addImageArray:(NSArray *)imageArray {
    [self.dataArray BPT_addObjectsFromArray:imageArray];
    [self addPlaceHolderOrNot];
    [self.collectionView reloadData];
}

- (void)removeAt:(NSUInteger)index {
    [self.dataArray BPT_removeObjAtIndex:index];
    [self addPlaceHolderOrNot];
    [self.collectionView reloadData];
}

- (void)addPlaceHolderOrNot {
    [self.dataArray bpw_removeObjectsWithClass:BPWPlaceHolder.class];
    if (self.dataArray.count == self.maxPickCount) {
        return;
    }
    BPWPlaceHolder *placeHolder = [[BPWPlaceHolder alloc] init];
    [self.dataArray addObject:placeHolder];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.dataArray  count];
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.dataArray BPT_objAtIndex:indexPath.row];
    Class cellClass = [self.cellClassArray firstObject];
    NSString *identifier = [BPWUtil identifierWithViewName:NSStringFromClass(cellClass)];
    UICollectionViewCell<BPWDataViewProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setViewWithModel:model];
    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20.0f, 30.0f, 20.0f, 30.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
        return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = [self.cellClassArray firstObject];
    return [cellClass collectionViewCellSize];
}


#pragma mark -
#pragma mark - UICollectionView Deleage
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.dataArray BPT_objAtIndex:indexPath.row];
    if ([model isKindOfClass:BPWPlaceHolder.class]) {
        BPWImagePickerViewController *imagePickerViewController = (BPWImagePickerViewController *)[collectionView BPT_viewController];
        [imagePickerViewController loadImage:indexPath];
    }
    else {
        NSMutableArray *imageArray =  [self.dataArray mutableCopy];
        [imageArray bpw_removeObjectsWithClass:BPWPlaceHolder.class];
        BPWImageCell *imageCell = [collectionView cellForItemAtIndexPath:indexPath];
        [BPWUtil showPhotoBrowserWithImageArray:imageArray imageViewArray:@[imageCell.imageViewForBrowser]  currentImageIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark - lazy load
- (NSArray *)cellClassArray {
    if (!_cellClassArray) {
        _cellClassArray = @[BPWImageCell.class];
    }
    return _cellClassArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
