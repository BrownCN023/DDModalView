//
//  CustomView.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/14.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (DDModalPopAnimation)showPopAnimation{
    return DDModalPopAnimationLeft;
}
- (DDModalPopAnimation)hidePopAnimation{
    return DDModalPopAnimationBottom;
}

- (CGFloat)topHeight{
    return 44.0;
}

- (CGFloat)bottomHeight{
    return 60;
}

- (CGFloat)contentHeight{
    return 200;
}

- (void)setupSubviews{
    [super setupSubviews];
    self.topView.backgroundColor = UIColor.redColor;
    self.contentView.backgroundColor = UIColor.greenColor;
    self.bottomView.backgroundColor = UIColor.blueColor;
}

@end
