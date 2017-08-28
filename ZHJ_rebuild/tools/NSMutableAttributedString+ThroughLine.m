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
+ (NSMutableAttributedString *)returnThroughLineWithText:(NSString *)text font:(CGFloat)font
{
    text = [NSString stringWithFormat:@"¥%@", text];
    NSDictionary *dict = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleThick],   NSStrikethroughColorAttributeName:[UIColor  grayColor], NSFontAttributeName:[UIFont systemFontOfSize:font]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attribtStr addAttributes:dict range:NSMakeRange(0, text.length)];
    
    return attribtStr;
}

@end
