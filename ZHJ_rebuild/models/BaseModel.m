//
//  BaseModel.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"存在未定义字段");
}

@end
