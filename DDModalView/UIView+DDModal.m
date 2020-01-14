//
//  UIView+DDModal.m
//  DDModalDemo
//
//  Created by TongAn001 on 2018/5/31.
//  Copyright © 2018年 abiang. All rights reserved.
//

#import "UIView+DDModal.h"

@implementation UIView (DDModal)

- (void)modalLayerCorners:(UIRectCorner)corners cornerSize:(CGSize)cornerSize{
    [self modalLayerCorners:corners cornerRect:self.bounds cornerSize:cornerSize];
}

- (void)modalLayerCorners:(UIRectCorner)corners cornerRect:(CGRect)cornerRect cornerSize:(CGSize)cornerSize{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cornerRect byRoundingCorners:corners cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cornerRect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (void)modalSimpleBorder:(DDModalBorderType)type width:(CGFloat)width color:(UIColor *)color{
    UIView * lineView = [self lineViewByType:type];
    if(lineView){
        lineView.backgroundColor = color;
        [self bringSubviewToFront:lineView];
        
        switch (type) {
            case DDModalBorderTypeTop:{
                [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.mas_equalTo(0);
                    make.height.mas_equalTo(width);
                }];
            }
                break;
            case DDModalBorderTypeLeft:{
                [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(width);
                }];
            }
                break;
            case DDModalBorderTypeBottom:{
                [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(width);
                }];
            }
                break;
            case DDModalBorderTypeRight:{
                [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.top.right.mas_equalTo(0);
                    make.width.mas_equalTo(width);
                }];
            }
                break;
            default:
                break;
        }
    }else{
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = color;
        if([self isKindOfClass:UIVisualEffectView.class]){
            UIVisualEffectView * selfview = (UIVisualEffectView *)self;
            [selfview.contentView addSubview:lineView];
        }else{
            [self addSubview:lineView];
        }
        
        switch (type) {
            case DDModalBorderTypeTop:{
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.mas_equalTo(0);
                    make.height.mas_equalTo(width);
                }];
            }
                break;
            case DDModalBorderTypeLeft:{
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(width);
                }];
            }
                break;
            case DDModalBorderTypeBottom:{
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(width);
                }];
            }
                break;
            case DDModalBorderTypeRight:{
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.top.right.mas_equalTo(0);
                    make.width.mas_equalTo(width);
                }];
            }
                break;
            default:
                break;
        }
        
    }
    
}

- (UIView *)lineViewByType:(DDModalBorderType)type{
    return [self viewWithTag:(99990+type)];
}

@end
