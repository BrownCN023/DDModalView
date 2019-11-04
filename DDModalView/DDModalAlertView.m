//
//  DDModalAlertView.m
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

@interface DDModalAlertView ()
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * bottomView;
@end

@implementation DDModalAlertView

#pragma mark - Override
- (DDModalPopAnimation)showPopAnimation{
    return DDModalPopAnimationScale;
}

- (DDModalPopAnimation)hidePopAnimation{
    return DDModalPopAnimationScale;
}

- (CGFloat)popHeight{
    return self.topHeight+self.contentHeight+self.bottomHeight;
}
- (CGFloat)topHeight{
    return 48.0f;
}
- (CGFloat)contentHeight{
    return 280.0f;
}
- (CGFloat)bottomHeight{
    return 48.0f;
}
#pragma mark - Setup
- (void)setupData{
    [super setupData];
}
- (void)setupSubviews{
    [super setupSubviews];
    [self.popView addSubview:self.topView];
    [self.popView addSubview:self.contentView];
    [self.popView addSubview:self.bottomView];
    
}
- (void)setupLayout{
    [super setupLayout];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.popView);
        make.height.mas_equalTo(self.topHeight);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.popView);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(self.contentHeight);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.popView);
        make.height.mas_equalTo(self.bottomHeight);
    }];
}

#pragma mark - Setting/Getting
- (UIView *)topView{
    if(!_topView){
        UIView * v = [[UIView alloc] init];
        v.backgroundColor = UIColor.whiteColor;
        _topView = v;
    }
    return _topView;
}

- (UIView *)contentView{
    if(!_contentView){
        UIView * v = [[UIView alloc] init];
        v.backgroundColor = UIColor.whiteColor;
        _contentView = v;
    }
    return _contentView;
}

- (UIView *)bottomView{
    if(!_bottomView){
        UIView * v = [[UIView alloc] init];
        v.backgroundColor = UIColor.whiteColor;
        _bottomView = v;
    }
    return _bottomView;
}

@end
