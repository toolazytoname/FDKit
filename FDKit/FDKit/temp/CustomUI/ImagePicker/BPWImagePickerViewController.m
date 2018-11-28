//
//  BPWImagePicker.m
//  AFNetworking
//
//  Created by Yiche on 2018/8/30.
//

#import "BPWImagePickerViewController.h"
#import "BPTImagePickerProtocol.h"
#import "BPWImagePickCollectionViewDelegate.h"
#import "BPWImagePickNetworkDelegate.h"
#import "BPBServiceManager.h"
#import "UIView+BPTAdditions.h"
#import "BPWUploadImage.h"
#import "NSArray+BPTSafe.h"

@interface BPWImagePickerViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger maxPickCount;
@property (nonatomic, strong) BPWImagePickCollectionViewDelegate *collectionViewDelegate;
@property (nonatomic, strong) BPWImagePickNetworkDelegate *networkDelegate;
@property (nonatomic, strong) NSMutableArray *uploadImageArray;
@property (nonatomic, strong) NSArray *imageUrlArray;
@end

@implementation BPWImagePickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil maxPickCount:(NSUInteger)maxPickCount {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.maxPickCount = maxPickCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionViewDelegate addImageArray:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteInImageCell:(id)sender {
    UICollectionViewCell *collectionViewCell = [[sender superview] superview];;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:collectionViewCell];
    [self.collectionViewDelegate removeAt:indexPath.row];
    [self.uploadImageArray BPT_removeObjAtIndex:indexPath.row];
    [self heightChangeBlockCalled];
}

- (void)loadImage:(NSIndexPath *)indexPath {
    id<BPTImagePickerProtocol> imagePickService  = [[BPBServiceManager sharedManager] createService:@protocol(BPTImagePickerProtocol)];
    [imagePickService presentImagePickerWithSelectLimit:self.maxPickCount - indexPath.row completeHandle:^(NSArray *assets) {
        dispatch_group_t uploadGroup = dispatch_group_create();
//        previewPhoto thumbPhoto
        NSArray *imageArray = [assets valueForKey:@"thumbPhoto"];
//        [self.collectionViewDelegate addImageArray:imageArray];
//        [self heightChangeBlockCalled];
//        return;
        
        [imageArray enumerateObjectsUsingBlock:^(UIImage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_group_enter(uploadGroup);
            [self.networkDelegate uploadImage:obj sucessBlock:^(id data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BPWUploadImage *uploadImage = [[BPWUploadImage alloc] init];
                    uploadImage.image = obj;
                    uploadImage.url = data;
                    [self.uploadImageArray addObject:uploadImage];
                    [self.collectionViewDelegate addImageArray:@[obj]];
                    dispatch_group_leave(uploadGroup);
                });
            } failureBlock:^{
                dispatch_group_leave(uploadGroup);
            }];
        }];
        dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
            [self heightChangeBlockCalled];
        }) ;
    }];
}

- (NSArray *)imageUrlArray {
     _imageUrlArray = [self.uploadImageArray valueForKey:@"url"];
    return _imageUrlArray;
}


- (void)heightChangeBlockCalled {
    CGFloat collectionViewHeight = 138.0f;
    if (self.collectionViewDelegate.dataArray.count > 3) {
        collectionViewHeight = 138.0f + 98.0f + 10.0f;
    }
    self.heightChangeBlock(collectionViewHeight);
}

- (BPWImagePickCollectionViewDelegate *)collectionViewDelegate {
    if (!_collectionViewDelegate) {
        _collectionViewDelegate = [[BPWImagePickCollectionViewDelegate alloc] initWithCollectionView:self.collectionView];
        _collectionViewDelegate.maxPickCount = self.maxPickCount;
    }
    return _collectionViewDelegate;
}
- (BPWImagePickNetworkDelegate *)networkDelegate {
    if (!_networkDelegate) {
        _networkDelegate = [[BPWImagePickNetworkDelegate alloc] init];
    }
    return _networkDelegate;
}

- (NSMutableArray *)uploadImageArray {
    if (!_uploadImageArray) {
        _uploadImageArray = [[NSMutableArray alloc] init];
    }
    return _uploadImageArray;
}

@end
