//
//  DDModalAlertView.m
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

@interface DDModalContentView()

@property (nonatomic,strong) UIVisualEffectView * effectView;

@end

@implementation DDModalContentView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}



@end



@interface DDModalAlertView ()
@property (nonatomic,strong) DDModalContentView * topView;
@property (nonatomic,strong) DDModalContentView * contentView;
@property (nonatomic,strong) DDModalContentView * bottomView;
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
- (BOOL)topIsEffectView{
    return YES;
}
- (BOOL)contentIsEffectView{
    return YES;
}
- (BOOL)bottomIsEffectView{
    return YES;
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
- (DDModalContentView *)topView{
    if(!_topView){
        DDModalContentView * v = [[DDModalContentView alloc] init];
        _topView = v;
    }
    return _topView;
}

- (DDModalContentView *)contentView{
    if(!_contentView){
        DDModalContentView * v = [[DDModalContentView alloc] init];
        _contentView = v;
    }
    return _contentView;
}

- (DDModalContentView *)bottomView{
    if(!_bottomView){
        DDModalContentView * v = [[DDModalContentView alloc] init];
        _bottomView = v;
    }
    return _bottomView;
}

@end
