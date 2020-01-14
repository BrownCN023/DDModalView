//
//  DDModalView.m
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalView.h"

#define DDModalViewTag 10031003

@interface DDModalView ()

@property (nonatomic,strong) UIView * modalView;

@end

@implementation DDModalView

- (void)dealloc{
    NSLog(@"--- dealloc %@ ---",self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _setupSubviews];
        [self _setupLayout];
        [self setup];
    }
    return self;
}

#pragma mark - Private Method
- (void)_setupSubviews{
    [self addSubview:self.modalView];
}
- (void)_setupLayout{
    self.modalView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Public Method
- (void)tapModalView:(UITapGestureRecognizer *)tapGes{
    [self dismiss:nil];
}

- (void)resetSetup{
    [self setupData];
    [self setupSubviews];
    [self setupLayout];
    
    [self layoutIfNeeded];
}

- (void)setup{
    [self resetSetup];
}

- (void)setupData{
    
}
- (void)setupSubviews{
    
}
- (void)setupLayout{
    
}
- (CGFloat)modalColorAlpha{
    return 0.35;
}
- (CGFloat)showAnimatedDuration{
    return 0.45;
}
- (CGFloat)hideAnimatedDuration{
    return 0.45;
}
- (CGFloat)springDamping{
    return 1.0;
}
- (CGFloat)springVelocity{
    return 0.1;
}
- (void)subviewShowAnimation{
    
}
- (void)subviewHideAnimation{
    
}

#pragma mark - Public
- (void)show:(DDModalCompletion)completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self viewShowAnimation:completion];
    });
}
- (void)dismiss:(DDModalCompletion)completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self viewHideAnimation:^{
            [self removeFromSuperview];
        }];
    });
}

- (void)viewShowAnimation:(DDModalCompletion)completion{
    [UIView animateWithDuration:[self showAnimatedDuration]
                          delay:0
         usingSpringWithDamping:self.springDamping
          initialSpringVelocity:self.springVelocity
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.modalView.alpha = 1;
        [self subviewShowAnimation];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(completion){
            completion();
        }
    }];
}

- (void)viewHideAnimation:(DDModalCompletion)completion{
    [UIView animateWithDuration:[self showAnimatedDuration]
                          delay:0
         usingSpringWithDamping:self.springDamping
          initialSpringVelocity:self.springVelocity
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.modalView.alpha = 0;
        [self subviewHideAnimation];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(completion){
            completion();
        }
    }];
}

#pragma mark - Setting/Getting
- (UIView *)modalView{
    if(!_modalView){
        UIView * v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.modalColorAlpha];
        v.alpha = 0.0f;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModalView:)];
        [v addGestureRecognizer:tap];
        _modalView = v;
    }
    return _modalView;
}


@end
