//
//  TestLeftMenuView.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2019/10/30.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "TestLeftMenuView.h"

@implementation TestLeftMenuView

+ (void)showLeftMenuInView:(UIView *)view{
    TestLeftMenuView * modalView = [[TestLeftMenuView alloc] initWithFrame:view.bounds];
    [view addSubview:modalView];
    [modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [modalView resetSetup];
    [modalView show:nil];
}

- (void)setup{}
- (DDModalPopAnimation)showPopAnimation{return DDModalPopAnimationLeft;}
- (DDModalPopAnimation)hidePopAnimation{return DDModalPopAnimationLeft;}
- (CGSize)cornerSize{return CGSizeZero;}
- (CGFloat)popMarginLeft{return 0;}
- (CGFloat)popMarginRight{return [UIScreen mainScreen].bounds.size.width*0.33;}
- (CGFloat)topHeight{return 0;}
- (CGFloat)bottomHeight{return 0;}
- (CGFloat)contentHeight{
    return self.superview.bounds.size.height;
}

@end
