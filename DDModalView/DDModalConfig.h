//
//  DDModalConfig.h
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/14.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDModalConfig : NSObject

@property (nonatomic,strong) UIColor * topBackgroundColor;
@property (nonatomic,strong) UIColor * contentBackgroundColor;
@property (nonatomic,strong) UIColor * separatorColor;
@property (nonatomic,strong) UIColor * selectedBackgroundColor;
@property (nonatomic,strong) UIColor * sectionFooterBackgroundColor;

@property (nonatomic,strong) UIFont * titleFont;
@property (nonatomic,strong) UIColor * titleColor;

@property (nonatomic,strong) UIFont * messageFont;
@property (nonatomic,strong) UIColor * messageColor;

@property (nonatomic,strong) UIFont * itemFont;
@property (nonatomic,strong) UIColor * itemColor;

@property (nonatomic,strong) UIFont * cancelFont;
@property (nonatomic,strong) UIColor * cancelColor;
@property (nonatomic,strong) UIColor * cancelBackgroundColor;

@property (nonatomic,strong) UIFont * okFont;
@property (nonatomic,strong) UIColor * okColor;
@property (nonatomic,strong) UIColor * okBackgroundColor;

+ (DDModalConfig *)sharedConfig;

@end

NS_ASSUME_NONNULL_END
