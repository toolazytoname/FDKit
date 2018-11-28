//
//  FDImageTool.m
//  FDImageToolDemo
//
//  Created by weichao on 16/9/30.
//  Copyright © 2016年 chaowei. All rights reserved.
//

#import "BPWImageTool.h"

@implementation BPWImageTool
+ (UIImage *)ellipseImageWithPureColor:(UIColor *)color imageSize:(CGSize)imageSize {
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    //another way
    //    CGContextAddArc(context, imageSize.width/2, imageSize.height/2, imageSize.width/2, 0, 2*M_PI, 0);
    //    CGContextDrawPath(context, kCGPathFill); //填充路径
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)rectangleImageWithPureColor:(UIColor *)color imageSize:(CGSize)imageSize {
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)rectangleGradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradientDirectionType:(BPWGradientDirectionType)gradientDirectionType imageSize:(CGSize)imageSize {
    if (!fromColor || !toColor) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [[self class] drawLinearGradientFromColor:fromColor toColor:toColor gradientType:gradientDirectionType frame:frame context:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)rectangleGradientImageWithColors:(NSArray*)colors ranges:(NSArray *)ranges gradientDirectionType:(BPWGradientDirectionType)gradientDirectionType imageSize:(CGSize)imageSize {
    if (colors.count < 2) {
        return nil;
    }
    //this two directions are not implemented 
    if (BPWGradientDirectionTypeTopLeftToDownRight == gradientDirectionType || BPWGradientDirectionTypeTopRightToDownLeft == gradientDirectionType) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //draw step by step with two colors
    for (NSInteger i = 0; i+1 < colors.count; i++) {
        UIColor *fromColor = colors[i];
        UIColor *toColor = colors[i + 1];
        CGFloat startPoint = [ranges[i] floatValue];
        CGFloat endPoint = [ranges[i+1] floatValue];
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGRect frame = CGRectZero;
        switch (gradientDirectionType) {
            case BPWGradientDirectionTypeTopToBottom:
                frame = CGRectMake(0.0f, height*startPoint, width, height*(endPoint - startPoint));
                break;
            case BPWGradientDirectionTypeLeftToRight:
                frame = CGRectMake(width * startPoint, 0.0f, width*(endPoint - startPoint), height);
                break;
            default:
                break;
        }
        [[self class] drawLinearGradientFromColor:fromColor toColor:toColor gradientType:gradientDirectionType frame:frame context:context];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

+ (void)drawLinearGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradientType:(BPWGradientDirectionType)gradientType frame:(CGRect)frame context:(CGContextRef)context {
    if (!fromColor || !toColor) {
        return;
    }
    NSArray *colors = @[(id)fromColor.CGColor,(id)toColor.CGColor];
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(toColor.CGColor);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    CGPoint start = CGPointZero;
    CGPoint end = CGPointZero;
    switch (gradientType) {
        case BPWGradientDirectionTypeTopToBottom:
            //top left
            start = frame.origin;
            //down left
            end = CGPointMake(frame.origin.x,CGRectGetMaxY(frame));
            break;
        case BPWGradientDirectionTypeLeftToRight:
            //top left
            start = frame.origin;
            //top right
            end = CGPointMake(CGRectGetMaxX(frame), frame.origin.y);
            break;
        case BPWGradientDirectionTypeTopLeftToDownRight:
            //top left
            start = frame.origin;
            //down right
            end = CGPointMake(CGRectGetMaxX(frame),CGRectGetMaxY(frame));
            break;
        case BPWGradientDirectionTypeTopRightToDownLeft:
            //top right
            start = CGPointMake(CGRectGetMaxX(frame), frame.origin.y);
            //down left
            end = CGPointMake(frame.origin.x,CGRectGetMaxY(frame));
            break;
        default:
            break;
    }
    //pay attention to this parameter when you painting step by step(CGGradientDrawingOptions options) kCGGradientDrawsBeforeStartLocation| kCGGradientDrawsAfterEndLocation
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorSpace);
}

@end
