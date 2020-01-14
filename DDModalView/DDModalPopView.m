//
//  DDModalPopView.m
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalPopView.h"

@interface DDModalPopView()

@property (nonatomic,strong) UIView * popView;

@end

@implementation DDModalPopView


#pragma mark - Override
- (CGFloat)showAnimatedDuration{
    if(self.popHeight < DDModalViewHeight(self)/2.0){
        return 0.45;
    }
    return 0.55;
}
- (CGFloat)hideAnimatedDuration{
    if(self.popHeight < DDModalViewHeight(self)/2.0){
        return 0.45;
    }
    return 0.55;
}

- (DDModalPopAnimation)showPopAnimation{
    return DDModalPopAnimationNone;
}
- (DDModalPopAnimation)hidePopAnimation{
    return DDModalPopAnimationNone;
}

- (CGFloat)popMarginLeft{
    return 53.0f;
}
- (CGFloat)popMarginRight{
    return 53.0f;
}
- (CGFloat)popHeight{
    return 240.0f;
}
- (CGFloat)popMarginBottom{
    return (DDModalSelfHeight-self.popHeight)/2.0f;
}
- (CGSize)cornerSize{
    return CGSizeMake(13.5, 13.5);
}
- (UIRectCorner)corners{
    return UIRectCornerAllCorners;
}

- (CGFloat)popWidth{
    return DDModalSelfWidth-self.popMarginRight-self.popMarginLeft;
}

#pragma mark - ---------------
- (CGFloat)targetInitBottomConstant{
    if(self.showPopAnimation == DDModalPopAnimationTop){
        return -DDModalSelfHeight;
    }
    if(self.showPopAnimation == DDModalPopAnimationBottom){
        return self.popHeight;
    }
    return -self.popMarginBottom;
}

- (CGFloat)targetHideBottomConstant{
    if(self.hidePopAnimation == DDModalPopAnimationTop){
        return -DDModalSelfHeight;
    }
    if(self.hidePopAnimation == DDModalPopAnimationBottom){
        return self.popHeight;
    }
    return -self.popMarginBottom;
}

- (CGFloat)targetInitLeftConstant{
    if(self.showPopAnimation == DDModalPopAnimationLeft){
        return -self.popWidth;
    }
    if(self.showPopAnimation == DDModalPopAnimationRight){
        return DDModalSelfWidth;
    }
    return self.popMarginLeft;
}

- (CGFloat)targetHideLeftConstant{
    if(self.hidePopAnimation == DDModalPopAnimationLeft){
        return -self.popWidth;
    }
    if(self.hidePopAnimation == DDModalPopAnimationRight){
        return DDModalSelfWidth;
    }
    return self.popMarginLeft;
}

- (void)subviewShowAnimation{
    DDModalPopAnimation animation = self.showPopAnimation;
    switch (animation) {
        case DDModalPopAnimationTop:
        case DDModalPopAnimationBottom:{
            [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-self.popMarginBottom);
            }];
        }
            break;
        case DDModalPopAnimationLeft:
        case DDModalPopAnimationRight:{
            [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(self.popMarginLeft);
            }];
        }
            break;
        case DDModalPopAnimationScale:{
            self.popView.transform = CGAffineTransformIdentity;
            self.popView.alpha = 1.0f;
        }
            break;
        default:{
            self.popView.alpha = 1.0f;
        }
            break;
    }
}
- (void)subviewHideAnimation{
    DDModalPopAnimation animation = self.hidePopAnimation;
    switch (animation) {
        case DDModalPopAnimationTop:
        case DDModalPopAnimationBottom:{
            [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(self.targetHideBottomConstant);
            }];
        }
            break;
        case DDModalPopAnimationRight:
        case DDModalPopAnimationLeft:{
            [self.popView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(self.targetHideLeftConstant);
            }];
        }
            break;
        case DDModalPopAnimationScale:{
            self.popView.transform = CGAffineTransformScale(self.popView.transform, 0.95, 0.95);
            self.popView.alpha = 0.0f;
        }
            break;
        default:{
            self.popView.alpha = 0.0f;
        }
            break;
    }
}

#pragma mark - Setup
- (void)setupData{
    [super setupData];
}
- (void)setupSubviews{
    [super setupSubviews];
    [self addSubview:self.popView];
    [self.popView modalLayerCorners:self.corners
                         cornerRect:CGRectMake(0, 0, self.popWidth, self.popHeight)
                         cornerSize:self.cornerSize];
}
- (void)setupLayout{
    [super setupLayout];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.targetInitLeftConstant);
        make.width.mas_equalTo(self.popWidth);
        make.height.mas_equalTo(self.popHeight);
        make.bottom.equalTo(self).offset(self.targetInitBottomConstant);
    }];
}

#pragma mark - Setting/Getting
- (UIView *)popView{
    if(!_popView){
        UIView * v = [[UIView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        if(self.showPopAnimation == DDModalPopAnimationScale){
            v.transform = CGAffineTransformScale(v.transform, 1.05, 1.05);
            v.alpha = 0;
        }
        if(self.showPopAnimation == DDModalPopAnimationNone){
            v.alpha = 0;
        }
        _popView = v;
    }
    return _popView;
}

@end
