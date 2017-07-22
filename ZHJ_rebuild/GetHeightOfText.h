//
//  GetHeightOfText.h
//  fixit
//
//  Created by keda on 16/11/15.
//  Copyright © 2016年 keda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetHeightOfText : NSObject

+(CGFloat)getHeightWithContent:(NSString *)content font:(CGFloat)font contentSize:(CGSize)contentSize;

@end
