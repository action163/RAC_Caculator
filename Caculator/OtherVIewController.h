//
//  OtherVIewController.h
//  Caculator
//
//  Created by jzl on 16/5/20.
//  Copyright © 2016年 jiaozhenlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@interface OtherVIewController : UIViewController
@property(nonatomic,strong)RACSubject* delegateSignal;
@end
