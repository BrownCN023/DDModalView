//
//  UIView+DDModal.h
//  DDModalDemo
//
//  Created by TongAn001 on 2018/5/31.
//  Copyright © 2018年 abiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger,DDModalBorderType) {
    DDModalBorderTypeTop = 0,
    DDModalBorderTypeLeft,
    DDModalBorderTypeBottom,
    DDModalBorderTypeRight
};

@interface UIView (DDModal)

- (void)modalLayerCorners:(UIRectCorner)corners cornerSize:(CGSize)cornerSize;
- (void)modalLayerCorners:(UIRectCorner)corners cornerRect:(CGRect)cornerRect cornerSize:(CGSize)cornerSize;
- (void)modalSimpleBorder:(DDModalBorderType)type width:(CGFloat)width color:(UIColor *)color;


@end
