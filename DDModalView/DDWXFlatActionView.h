//
//  DDWXFlatActionView.h
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/14.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDWXFlatActionView : DDModalAlertView

+ (DDWXFlatActionView *)showActionInView:(UIView *)view
                                   title:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                           onCancelBlock:(void (^)(void))onCancelBlock
                              otherItems:(NSArray<NSString *> *)otherItems
                             onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDWXFlatActionView *)actionInView:(UIView *)view
                               title:(NSString *)title
                             message:(NSString *)message
                              cancel:(NSString *)cancel
                       onCancelBlock:(void (^)(void))onCancelBlock
                          otherItems:(NSArray<NSString *> *)otherItems
                         onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;


+ (DDWXFlatActionView *)showFlatActionInView:(UIView *)view
                                       title:(NSString *)title
                                     message:(NSString *)message
                                      cancel:(NSString *)cancel
                               onCancelBlock:(void (^)(void))onCancelBlock
                                  otherItems:(NSArray<NSString *> *)otherItems
                                 onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDWXFlatActionView *)flatActionInView:(UIView *)view
                                   title:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                           onCancelBlock:(void (^)(void))onCancelBlock
                              otherItems:(NSArray<NSString *> *)otherItems
                             onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

@end

NS_ASSUME_NONNULL_END
