//
//  NSString+ContentWidth.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContentWidth)

+(CGFloat)getWidthWithContent:(NSString *)content font:(CGFloat)font contentSize:(CGSize)contentSize;

@end
