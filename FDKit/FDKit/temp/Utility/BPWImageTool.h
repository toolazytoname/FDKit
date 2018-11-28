//
//  FDImageTool.h
//  FDImageToolDemo
//
//  Created by weichao on 16/9/30.
//  Copyright © 2016年 chaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  渐变方向枚举
 */
typedef NS_ENUM(NSInteger,BPWGradientDirectionType) {
    /**
     *  从上到下
     */
    BPWGradientDirectionTypeTopToBottom = 0,
    /**
     *  从左到右
     */
    BPWGradientDirectionTypeLeftToRight = 1,
    /**
     *  左上到右下
     */
    BPWGradientDirectionTypeTopLeftToDownRight = 2,
    /**
     *  右上到左下
     */
    BPWGradientDirectionTypeTopRightToDownLeft = 3,
};



@interface BPWImageTool : NSObject

/**
 *  generate a ellipse UIImage with one pure Color
 *
 *  @param color     color of image
 *  @param imageSize rectangle size outside ellipse
 *
 *  @return a ellipse UIImage with one pure Color
 */
+ (UIImage *)ellipseImageWithPureColor:(UIColor *)color imageSize:(CGSize)imageSize;


/**
 *  generate a rectangle UIImage with one pure Color
 *
 *  @param color     color of image
 *  @param imageSize rectangle size
 *
 *  @return a rectangle UIImage with one pure Color
 */
+ (UIImage *)rectangleImageWithPureColor:(UIColor *)color imageSize:(CGSize)imageSize;

/**
 *  generate a a rectangle UIImagea rectangle UIImage with gradient
 sample: self.upLeftToLowRightImageView.image = [FDImageTool rectangleGradientImageFromColor:[UIColor redColor] toColor:[UIColor yellowColor] gradientDirectionType:GradientDirectionTypeTopLeftToDownRight imageSize:self.upLeftToLowRightImageView.frame.size];
 *
 *  @param fromColor                color at the start Point
 *  @param toColor                  color at the end Point
 *  @param gradientDirectionType    gradient direction enum
 *  @param imageSize                the size of generated image
 *
 *  @return a rectangle UIImagea rectangle UIImage with gradient
 */
+ (UIImage *)rectangleGradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradientDirectionType:(BPWGradientDirectionType)gradientDirectionType imageSize:(CGSize)imageSize;

/**
 *
 Generate a complicated rectangle UIImagea rectangle UIImage with gradient
 sample:
 self.stepGradientImageImageView1.image = [FDImageTool rectangleGradientImageWithColors:@[[UIColor redColor],[UIColor yellowColor],[UIColor purpleColor]] ranges:@[@(0),@(0.5),@(1)] gradientDirectionType:GradientDirectionTypeLeftToRight imageSize:self.stepGradientImageImageView1.frame.size];
 *
 *  @param colors                colors array which contains two objects at least. sample： @[[UIColor redColor],[UIColor redColor],[UIColor greenColor]]
 *  @param ranges                ranges array whick contains NSNumber sample:@[@(0),@(0.2),@(1)]
 *  @param gradientDirectionType gradient direction enum(only support GradientDirectionTypeTopToBottom and  GradientDirectionTypeLeftToRight )
 *  @param imageSize             the size of generated image
 *
 *  @return a rectangle UIImagea rectangle UIImage with gradient
 */
+ (UIImage *)rectangleGradientImageWithColors:(NSArray*)colors ranges:(NSArray *)ranges gradientDirectionType:(BPWGradientDirectionType)gradientDirectionType imageSize:(CGSize)imageSize;

@end
