//
//  BPWImageCell.m
//  AFNetworking
//
//  Created by Yiche on 2018/8/30.
//

#import "BPWImageCell.h"
#import "BPWUtil.h"
#import "BPWPlaceHolder.h"
#import "UIView+BPTAdditions.h"
#import "UIView+BPWRadius.h"

@interface BPWImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end
@implementation BPWImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.closeButton setImage:[BPWUtil imageInBundleWithName:@"fabu_ico_delate"] forState:UIControlStateNormal];
    [self.closeButton addTarget:nil action:@selector(deleteInImageCell:) forControlEvents:UIControlEventTouchUpInside];
//    self.closeButton.layer.cornerRadius = 8.0f;
    [self.closeButton BPW_addRectCorner:UIRectCornerBottomLeft|UIRectCornerTopRight radius:6.0f];
    self.addImageView.image = [BPWUtil imageInBundleWithName:@"fabu_add"];
    [self BPW_addRectCorner:UIRectCornerAllCorners radius:8.0f];
}

- (UIImageView *)imageViewForBrowser{
    return self.contentImageView;
}
- (void)setViewWithModel:(id)model {
    if (!model) {
        return;
    }
    if ([model isKindOfClass:UIImage.class]) {
        self.contentImageView.image = (UIImage *)model;
        self.contentImageView.hidden = NO;
        self.closeButton.hidden = NO;
        self.addImageView.hidden = YES;
    }
    if ([model isKindOfClass:BPWPlaceHolder.class]) {
        self.contentImageView.hidden = YES;
        self.closeButton.hidden = YES;
        self.addImageView.hidden = NO;
        
    }
}
//collectionViewCellSize
+ (CGSize)collectionViewCellSize {
    return CGSizeMake(98.0f, 98.0f);
}
@end
