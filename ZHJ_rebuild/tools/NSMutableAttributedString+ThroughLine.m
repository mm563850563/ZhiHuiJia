//
//  NSMutableAttributedString+ThroughLine.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "NSMutableAttributedString+ThroughLine.h"

@implementation NSMutableAttributedString (ThroughLine)

//返回带中间穿过线的string
+ (NSMutableAttributedString *)returnThroughLineWithText:(NSString *)text
{
    //中划线
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,text.length)];
    
    return attributeMarket;
}

@end
