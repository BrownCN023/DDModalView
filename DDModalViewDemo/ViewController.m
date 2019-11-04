//
//  ViewController.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2019/10/29.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ViewController.h"
#import "DDSimpleActionView.h"
#import "DDSimpleAlertView.h"
#import "DDFlatActionView.h"
#import "TestLeftMenuView.h"

#import "ViewController2.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickAlertButton:(id)sender {
    [[DDSimpleAlertView showAlertInView:self.view title:@"相机权限" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" cancel:@"取消"  onCancelBlock:nil otherItems:@[@"打开权限"] onItemBlock:^(NSInteger itemIndex) {
        NSLog(@"itemIndex:%@",@(itemIndex));
//        [TestLeftMenuView showLeftMenuInView:self.view];
        ViewController2 * vctl = [ViewController2 new];
        [self.navigationController pushViewController:vctl animated:YES];

    }] show:nil];
}

- (IBAction)clickActionButton:(id)sender {
    [[DDFlatActionView showActionInView:[UIApplication sharedApplication].keyWindow title:nil message:@"操作提示" items:@[@"拍照",@"从相册选择",@"不玩了"] onItemBlock:^(NSInteger itemIndex) {
        NSLog(@"itemIndex:%@",@(itemIndex));
        [[DDSimpleActionView showActionInView:[UIApplication sharedApplication].keyWindow title:@"相机权限" message:@"App需要使用相机功能拍照片，去设置里面打开权限吧" cancel:@"取消"  onCancelBlock:nil otherItems:@[@"打开权限"] onItemBlock:^(NSInteger itemIndex) {
            NSLog(@"itemIndex:%@",@(itemIndex));
            
        }] show:nil];
    }] show:nil];
}

- (IBAction)clickFlatActionButton:(id)sender {
    [[DDFlatActionView showFlatActionInView:self.view title:nil message:@"操作提示" items:@[@"拍照",@"从相册选择",@"不玩了"] onItemBlock:^(NSInteger itemIndex) {
        NSLog(@"itemIndex:%@",@(itemIndex));
        [[DDFlatActionView showFlatActionInView:[UIApplication sharedApplication].keyWindow title:nil message:nil items:@[@"举报违规",@"关注他",@"取消"] onItemBlock:^(NSInteger itemIndex) {
            NSLog(@"itemIndex:%@",@(itemIndex));
            ViewController2 * vctl = [ViewController2 new];
            [self.navigationController pushViewController:vctl animated:YES];
        }] show:nil];
        
    }] show:nil];
}


@end
