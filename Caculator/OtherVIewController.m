//
//  OtherVIewController.m
//  Caculator
//
//  Created by jzl on 16/5/20.
//  Copyright © 2016年 jiaozhenlong. All rights reserved.
//

#import "OtherVIewController.h"


@implementation OtherVIewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 300, 100);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)notice{
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@"hello  world"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
