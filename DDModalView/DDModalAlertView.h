//
//  DDModalAlertView.h
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDModalContentView : UIView

@property (nonatomic,strong,readonly) UIVisualEffectView * effectView;

@end



@interface DDModalAlertView : DDModalPopView

@property (nonatomic,strong,readonly) DDModalContentView * topView;
@property (nonatomic,strong,readonly) DDModalContentView * contentView;
@property (nonatomic,strong,readonly) DDModalContentView * bottomView;

- (CGFloat)topHeight;
- (CGFloat)contentHeight;
- (CGFloat)bottomHeight;

@end

NS_ASSUME_NONNULL_END
