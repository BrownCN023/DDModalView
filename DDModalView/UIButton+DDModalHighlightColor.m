//
//  UIButton+DDHighlightColor.m
//  DDModalDemo
//
//  Created by TongAn001 on 2018/6/29.
//  Copyright © 2018年 abiang. All rights reserved.
//

#import "UIButton+DDModalHighlightColor.h"

@implementation UIButton (DDModalHighlightColor)

- (void)setHighlightColor:(UIColor *)highlightColor{
    UIImage * backgroundImage = [self createImageWithColor:highlightColor size:CGSizeMake(10, 10)];
    [self setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
}

- (UIColor *)highlightColor{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -self.center.x, -self.center.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
