//
//  DDModalConfig.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/14.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDModalConfig.h"
#import "DDModalView.h"

@implementation DDModalConfig

+ (DDModalConfig *)sharedConfig{
    static DDModalConfig * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDModalConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topBackgroundColor = DDModal_COLOR_HexA(0xFFFFFF,0.75);
        self.contentBackgroundColor = DDModal_COLOR_HexA(0xFFFFFF,0.75);
        self.separatorColor = DDModal_COLOR_HexA(0xDDDDDD,0.75);
        self.selectedBackgroundColor = DDModal_COLOR_HexA(0xDDDDDD,0.75);
        self.sectionFooterBackgroundColor = DDModal_COLOR_Hex(0xDDDDDD);
        
        self.titleFont = [UIFont boldSystemFontOfSize:16];
        self.titleColor = DDModal_COLOR_Hex(0x494949);
        
        self.messageFont = [UIFont systemFontOfSize:13];
        self.messageColor = DDModal_COLOR_Hex(0x7C7C7C);
        
        self.itemFont = [UIFont boldSystemFontOfSize:16];
        self.itemColor = DDModal_COLOR_Hex(0x494949);
        
        self.cancelFont = [UIFont boldSystemFontOfSize:16];
        self.cancelColor = DDModal_COLOR_Hex(0x494949);
        self.cancelBackgroundColor = DDModal_COLOR_HexA(0xFFFFFF,0.75);
        
        self.okFont = [UIFont boldSystemFontOfSize:16];
        self.okColor = DDModal_COLOR_Hex(0x494949);
        self.okBackgroundColor = DDModal_COLOR_HexA(0xFFFFFF,0.75);
        
    }
    return self;
}

@end
