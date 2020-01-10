//
//  DDFlatActionView.h
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/27.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFlatActionView : DDModalAlertView

+ (DDFlatActionView *)showActionInView:(UIView *)view
                                   title:(NSString *)title
                                 message:(NSString *)message
                              items:(NSArray<NSString *> *)items
                             onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDFlatActionView *)actionInView:(UIView *)view
                                 title:(NSString *)title
                               message:(NSString *)message
                                 items:(NSArray<NSString *> *)items
                           onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDFlatActionView *)flatActionInView:(UIView *)view
                                 title:(NSString *)title
                               message:(NSString *)message
                                 items:(NSArray<NSString *> *)items
                           onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;


+ (DDFlatActionView *)showFlatActionInView:(UIView *)view
                                 title:(NSString *)title
                               message:(NSString *)message
                                 items:(NSArray<NSString *> *)items
                           onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;




@end

NS_ASSUME_NONNULL_END
