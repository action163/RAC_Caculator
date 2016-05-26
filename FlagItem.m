//
//  FlagItem.m
//  Caculator
//
//  Created by jzl on 16/5/20.
//  Copyright © 2016年 jiaozhenlong. All rights reserved.
//

#import "FlagItem.h"

@implementation FlagItem
-(instancetype)initWithDic:(NSDictionary* )dict{
    if (self = [super init]) {
        self.icon = dict[@"icon"];
        self.name = dict[@"name"];
    }
    return self;
}
+(instancetype)flagWithDic:(NSDictionary* )dict{
    return [[self alloc] initWithDic:dict];
}
@end


