//
//  DDAlertView.h
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/13.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDModalAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertView : DDModalAlertView

+ (DDAlertView *)alertInView:(UIView *)view
                       title:(NSString *)title
                     message:(NSString *)message
                      cancel:(NSString *)cancel
               onCancelBlock:(void (^)(void))onCancelBlock
                  otherItems:(NSArray<NSString *> *)otherItems
                 onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

+ (DDAlertView *)showAlertInView:(UIView *)view
                           title:(NSString *)title
                         message:(NSString *)message
                          cancel:(NSString *)cancel
                   onCancelBlock:(void (^)(void))onCancelBlock
                      otherItems:(NSArray<NSString *> *)otherItems
                     onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock;

@end

NS_ASSUME_NONNULL_END
