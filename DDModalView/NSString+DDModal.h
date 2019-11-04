//
//  NSString+DDModal.h
//  DDModalDemo
//
//  Created by TongAn001 on 2018/5/31.
//  Copyright © 2018年 abiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DDModal)


- (NSAttributedString *)modalSimpleAttributedString:(UIFont *)font
                                         color:(UIColor *)color
                                   lineSpacing:(CGFloat)lineSpacing
                                     alignment:(NSTextAlignment)alignment;

@end
