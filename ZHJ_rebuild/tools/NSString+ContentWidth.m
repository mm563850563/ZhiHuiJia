//
//  NSString+ContentWidth.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "NSString+ContentWidth.h"

@implementation NSString (ContentWidth)

+(CGFloat)getWidthWithContent:(NSString *)content font:(CGFloat)font contentSize:(CGSize)contentSize
{
    if (content == nil){
        return 0;
    }
    
    CGSize measureSize;
    
    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
        
        measureSize = [content sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
    }else{
        
        measureSize = [content boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil] context:nil].size;
        
    }
    
    return ceil(measureSize.width);
}

@end
