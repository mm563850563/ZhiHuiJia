//
//  GetHeightOfText.m
//  fixit
//
//  Created by keda on 16/11/15.
//  Copyright © 2016年 keda. All rights reserved.
//

#import "GetHeightOfText.h"

@implementation GetHeightOfText

//傳字符串文本和字體返回高度
+(CGFloat)getHeightWithContent:(NSString *)content font:(CGFloat)font contentSize:(CGSize)contentSize
{
    CGRect rect = [content boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

@end
