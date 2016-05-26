//
//  FlagItem.h
//  Caculator
//
//  Created by jzl on 16/5/20.
//  Copyright © 2016年 jiaozhenlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagItem : NSObject

@property (nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *name;

-(instancetype)initWithDic:(NSDictionary* )dict;
+(instancetype)flagWithDic:(NSDictionary* )dict;
@end
