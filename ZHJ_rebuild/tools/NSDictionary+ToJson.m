//
//  NSDictionary+ToJson.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "NSDictionary+ToJson.h"

@implementation NSDictionary (ToJson)

#pragma mark - <字典转json>
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
