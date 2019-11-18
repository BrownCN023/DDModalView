//
//  DDModalView.h
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

#define DDModalSelfSize (self.bounds.size)
#define DDModalSelfWidth (DDModalSelfSize.width)
#define DDModalSelfHeight (DDModalSelfSize.height)

#define DDModalViewSize(view) (view.bounds.size)
#define DDModalViewWidth(view) (view.bounds.size.width)
#define DDModalViewHeight(view) (view.bounds.size.height)

#define DDModal_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define DDModal_COLOR_RGB(r,g,b) DDModal_COLOR_RGBA(r,g,b,1.0)
#define DDModal_COLOR_HexA(hex,a) DDModal_COLOR_RGBA(((hex & 0xFF0000) >> 16),((hex &0xFF00) >>8),(hex &0xFF),a)
#define DDModal_COLOR_Hex(hex) DDModal_COLOR_HexA(hex,1.0)

/// iPhone 5.8(X,XS)
#define DDModal_IPHONE_5_8 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
/// iPhone 6.1(XR)
#define DDModal_IPHONE_6_1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
/// iPhone 6.5(XS MAX)
#define DDModal_IPHONE_6_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define DDModal_IPHONE_X_TYPE (DDModal_IPHONE_5_8 || DDModal_IPHONE_6_1 || DDModal_IPHONE_6_5)
#define DDModal_SAFE_BOTTOM_HEIGHT (DDModal_IPHONE_X_TYPE ? 34.0f : 0.0f)


typedef void (^DDModalCompletion)(void);

@interface DDModalView : UIView

@property (nonatomic,strong,readonly) UIView * modalView;

- (void)resetSetup;
- (void)setup;
- (void)setupData;
- (void)setupSubviews;
- (void)setupLayout;

- (CGFloat)modalColorAlpha;
- (CGFloat)showAnimatedDuration;
- (CGFloat)hideAnimatedDuration;
- (CGFloat)springDamping;   //default 1
- (CGFloat)springVelocity;  //default 0.1

- (void)subviewShowAnimation;
- (void)subviewHideAnimation;

- (void)show:(DDModalCompletion _Nullable)completion;
- (void)dismiss:(DDModalCompletion _Nullable)completion;

- (void)viewShowAnimation:(DDModalCompletion _Nullable)completion;
- (void)viewHideAnimation:(DDModalCompletion _Nullable)completion;

- (void)tapModalView:(UITapGestureRecognizer *)tapGes;

@end

NS_ASSUME_NONNULL_END
