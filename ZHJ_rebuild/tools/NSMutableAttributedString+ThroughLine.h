//
//  NSMutableAttributedString+ThroughLine.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ThroughLine)

+ (NSMutableAttributedString *)returnThroughLineWithText:(NSString *)text font:(CGFloat)font;

@end
