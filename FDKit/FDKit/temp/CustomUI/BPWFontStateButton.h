//
//  BPWFontStateButton.h
//  AFNetworking
//
//  Created by Yiche on 2018/8/17.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

/**
 * A button that allows fonts to be assigned to each of the button's states.
 *
 * A state font can be specified using setFont:forState, or through one of the
 * four state Font properties.
 *
 * If a font is not specified for a given state, then
 * the System font will be displayed with a font size of 15.
 */
@interface BPWFontStateButton : UIButton
@property (strong, nonatomic) UIFont *normalFont;
@property (strong, nonatomic) UIFont *highlightedFont;
@property (strong, nonatomic) UIFont *selectedFont;
@property (strong, nonatomic) UIFont *disabledFont;

/**
 * Set a font for a button state.
 *
 * @param font  the font
 * @param state a control state -- can be
 *      UIControlStateNormal
 *      UIControlStateHighlighted
 *      UIControlStateDisabled
 *      UIControlStateSelected
 */
- (void)setFont:(UIFont *)font forState:(NSUInteger)state;

@end
