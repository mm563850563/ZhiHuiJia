//
//  WXApiManager.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXApiManager : NSObject

+(instancetype)sharedManager;
- (void)onResp:(BaseResp *)resp;

@end
