//
//  BPWLineHeightLabel.m
//  AFNetworking
//
//  Created by Yiche on 2018/9/19.
//

#import "BPWLineHeightLabel.h"

@implementation BPWLineHeightLabel

- (void)setText:(NSString *)text {
    if (!text.length || self.lineHeight==0) {
        return;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.maximumLineHeight = self.lineHeight;
    style.minimumLineHeight = self.lineHeight;
    style.lineBreakMode = self.lineBreakMode;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    self.attributedText = attrString;
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self setText:self.text];
}

@end
