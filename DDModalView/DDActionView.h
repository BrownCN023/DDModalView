//
//  DDActionView.h
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/13.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDActionView : DDModalAlertView

+ (DDActionView *)showActionInView:(UIView *)view
                             title:(NSString *)title
                           message:(NSString *)message
                            cancel:(NSString *)cancel
                     onCancelBlock:(void (^)(void))onCancelBlock
                        otherItems:(NSArray<NSString *> *)otherItems
                       onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDActionView *)actionInView:(UIView *)view
                         title:(NSString *)title
                       message:(NSString *)message
                        cancel:(NSString *)cancel
                 onCancelBlock:(void (^)(void))onCancelBlock
                    otherItems:(NSArray<NSString *> *)otherItems
                   onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

@end

NS_ASSUME_NONNULL_END
