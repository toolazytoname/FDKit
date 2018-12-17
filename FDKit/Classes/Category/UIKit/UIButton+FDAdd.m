//
//  UIButton+FDAdd.m
//  FDCategories
//
//  Created by weichao on 2018/11/19.
//  Copyright © 2018年 ibireme. All rights reserved.
//

#import "UIButton+FDAdd.h"
#import "UIColor+FDAdd.h"
#import "UIImage+FDAdd.h"

@implementation UIButton (FDAdd)
/**
 倒计时方法
 */
- (void)fd_sentPhoneCodeTimeMethodInSecond:(NSUInteger)duration {
    //倒计时时间 - 60S
    __block NSInteger timeOut = duration;
    //    self.timeOut = timeOut;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [self setTitle:@"重发验证码" forState:UIControlStateNormal];
                [self setTitleColor:FDColorHex(0x3377FF) forState:UIControlStateNormal];
                [self setEnabled:YES];
                [self setUserInteractionEnabled:YES];
            });
        } else {
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.01];
                NSString *title = [NSString stringWithFormat:@"%@s重新获取",strTime];
                [self setTitle:title forState:UIControlStateNormal];
                [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [self setTitleColor:FDColorHex(0xCCCCCC) forState:UIControlStateNormal];
                [UIView commitAnimations];
                //计时器间不允许点击
                [self setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

- (void)fd_setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    UIImage *colorImage = [UIImage fd_imageWithColor:color];
    [self setImage:colorImage forState:state];
}

@end
