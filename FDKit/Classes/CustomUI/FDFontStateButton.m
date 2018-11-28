//
//  BPWFontStateButton.m
//  AFNetworking
//
//  Created by Lazy on 2018/8/17.
//

#import "FDFontStateButton.h"

@implementation FDFontStateButton

//Sets one of the font properties, depending on which state was passed
- (void)setFont:(UIFont *)font forState:(NSUInteger)state
{
    switch (state) {
        case UIControlStateNormal:
        {
            self.normalFont = font;
            break;
        }
            
        case UIControlStateHighlighted:
        {
            self.highlightedFont = font;
            break;
        }
            
        case UIControlStateDisabled:
        {
            self.disabledFont = font;
            break;
        }
            
        case UIControlStateSelected:
        {
            self.selectedFont = font;
            break;
        }
            
        default:
        {
            self.normalFont = font;
            break;
        }
    }
}

/**
 * Overrides layoutSubviews in UIView, to set the font for the button's state,
 * before calling [super layoutSubviews].
 */
- (void)layoutSubviews
{
    NSUInteger state = self.state;
    
    switch (state) {
        case UIControlStateNormal:
        {
            [self setTitleFont:_normalFont];
            break;
        }
            
        case UIControlStateHighlighted:
        {
            [self setTitleFont:_highlightedFont];
            break;
        }
            
        case UIControlStateDisabled:
        {
            [self setTitleFont:_disabledFont];
            break;
        }
            
        case UIControlStateSelected:
        {
            [self setTitleFont:_selectedFont];
            break;
        }
            
        default:
        {
            [self setTitleFont:_normalFont];
            break;
        }
            
    }
    
    [super layoutSubviews];
}

/**
 * Private
 *
 * Convenience method that falls back to the System font,
 * if no font is configured.
 */
- (void)setTitleFont:(UIFont *)font
{
    if (!font) {
        font = [UIFont systemFontOfSize:15];
    }
    
    self.titleLabel.font = font;
}


@end
