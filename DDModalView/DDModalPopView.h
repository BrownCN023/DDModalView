//
//  DDModalPopView.h
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalView.h"
#import "UIView+DDModal.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DDModalPopAnimation) {
    DDModalPopAnimationNone = 0,
    DDModalPopAnimationScale,
    DDModalPopAnimationTop,
    DDModalPopAnimationRight,
    DDModalPopAnimationBottom,
    DDModalPopAnimationLeft
};

@interface DDModalPopView : DDModalView

@property (nonatomic,strong,readonly) UIView * popView;

- (DDModalPopAnimation)showPopAnimation;
- (DDModalPopAnimation)hidePopAnimation;
- (CGFloat)popMarginLeft;
- (CGFloat)popMarginRight;
- (CGFloat)popHeight;
- (CGFloat)popMarginBottom;
- (CGSize)cornerSize;
- (UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
