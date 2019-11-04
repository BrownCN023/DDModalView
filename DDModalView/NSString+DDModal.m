//
//  NSString+DDModal.m
//  DDModalDemo
//
//  Created by TongAn001 on 2018/5/31.
//  Copyright © 2018年 abiang. All rights reserved.
//

#import "NSString+DDModal.h"

@implementation NSString (DDModal)

- (NSAttributedString *)modalSimpleAttributedString:(UIFont *)font
                                         color:(UIColor *)color
                                   lineSpacing:(CGFloat)lineSpacing
                                     alignment:(NSTextAlignment)alignment{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    
    NSDictionary * attr = @{
                            NSParagraphStyleAttributeName:paragraphStyle,
                            NSFontAttributeName:font,
                            NSForegroundColorAttributeName:color
                            };
    return [[NSMutableAttributedString alloc] initWithString:self attributes:attr];
}

@end
