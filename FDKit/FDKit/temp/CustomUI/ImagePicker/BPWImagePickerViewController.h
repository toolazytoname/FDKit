//
//  BPWImagePicker.h
//  AFNetworking
//
//  Created by Yiche on 2018/8/30.
//

#import <UIKit/UIKit.h>
typedef void(^imagePickHeightChange)(float height);

@interface BPWImagePickerViewController : UIViewController
@property (nonatomic, copy) imagePickHeightChange heightChangeBlock;
@property (nonatomic, strong, readonly) NSArray *imageUrlArray;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil maxPickCount:(NSUInteger)maxPickCount;
- (void)loadImage:(NSIndexPath *)indexPath;


@end
