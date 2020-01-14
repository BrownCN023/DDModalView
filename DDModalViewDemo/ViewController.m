//
//  ViewController.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2019/10/29.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ViewController.h"

#import "DDFlatActionView.h"

#import "ViewController2.h"
#import "DDAlertView.h"
#import "DDActionView.h"
#import "DDModalConfig.h"
#import "DDWXFlatActionView.h"

#import "CustomView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    DDModalConfig.sharedConfig.cancelBackgroundColor = DDModal_COLOR_HexA(0x37C6C0,0.75);
//    DDModalConfig.sharedConfig.okBackgroundColor = DDModal_COLOR_HexA(0xF2753F,0.75);
//    DDModalConfig.sharedConfig.contentBackgroundColor = DDModal_COLOR_HexA(0xFF0000,0.35);
//    DDModalConfig.sharedConfig.topBackgroundColor = DDModal_COLOR_HexA(0xB8288A,0.35);
}

- (IBAction)clickAlertButton:(id)sender {
    [[DDAlertView alertInView:self.view title:@"相机权限" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" cancel:@"取消"  onCancelBlock:nil otherItems:@[@"打开相机"] onItemBlock:^(NSInteger itemIndex) {
        NSLog(@"itemIndex:%@",@(itemIndex));
        ViewController2 * vctl = [ViewController2 new];
        [self.navigationController pushViewController:vctl animated:YES];
    }] show:nil];
}

- (IBAction)clickActionButton:(id)sender {
    

    [DDActionView showActionInView:[UIApplication sharedApplication].keyWindow title:nil message:@"操作提示" cancel:@"取消" onCancelBlock:^{
        
    } otherItems:@[@"拍照",@"从相册选择",@"不玩了"] onItemBlock:^(NSInteger itemIndex) {
        [DDActionView showActionInView:[UIApplication sharedApplication].keyWindow title:@"相机权限" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" cancel:@"取消"  onCancelBlock:nil otherItems:@[@"打开权限"] onItemBlock:^(NSInteger itemIndex) {
            NSLog(@"itemIndex:%@",@(itemIndex));
            
        }];
    }];
}

- (IBAction)clickFlatActionButton:(id)sender {
    [DDFlatActionView showFlatActionInView:self.view title:@"哈哈哈哈" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" items:@[@"拍照",@"从相册选择",@"不玩了"] onItemBlock:^(NSInteger itemIndex) {
        NSLog(@"itemIndex:%@",@(itemIndex));
        [[DDFlatActionView actionInView:[UIApplication sharedApplication].keyWindow title:@"哈哈哈哈" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" items:@[@"举报违规",@"关注他",@"取消"] onItemBlock:^(NSInteger itemIndex) {
            NSLog(@"itemIndex:%@",@(itemIndex));
            ViewController2 * vctl = [ViewController2 new];
            [self.navigationController pushViewController:vctl animated:YES];
        }] show:nil];

    }];
}
- (IBAction)clickCustom:(id)sender {
    
    CustomView * modalView = [[CustomView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:modalView];
    
    [modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [modalView show:nil];
}
- (IBAction)clickWXAction:(id)sender {
    [DDWXFlatActionView showActionInView:self.view title:@"Hello" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" cancel:@"取消" onCancelBlock:nil otherItems:@[@"拍照",@"从相册选择"] onItemBlock:^(NSInteger itemIndex) {
        
        [DDWXFlatActionView showFlatActionInView:self.view title:@"Hello" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" cancel:@"取消" onCancelBlock:nil otherItems:@[@"拍照",@"从相册选择"] onItemBlock:^(NSInteger itemIndex) {
            
        }];
        
    }];
}

@end
