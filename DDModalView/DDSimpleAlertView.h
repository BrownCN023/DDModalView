//
//  DDSimpleAlertView.h
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSimpleAlertView : DDModalAlertView

+ (DDSimpleAlertView *)alertInView:(UIView *)view
                             title:(NSString *)title
                           message:(NSString *)message
                            cancel:(NSString *)cancel
                     onCancelBlock:(void (^)(void))onCancelBlock
                        otherItems:(NSArray<NSString *> *)otherItems
                       onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDSimpleAlertView *)showAlertInView:(UIView *)view
                                 title:(NSString *)title
                               message:(NSString *)message
                                cancel:(NSString *)cancel
                         onCancelBlock:(void (^)(void))onCancelBlock
                            otherItems:(NSArray<NSString *> *)otherItems
                           onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;



@end

NS_ASSUME_NONNULL_END
