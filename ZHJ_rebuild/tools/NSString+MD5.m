//
//  NSString+MD5.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

-(NSString *)md5WithInputText:(NSString *)inputText
{
    const char*cStr = [inputText UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *outputText = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [outputText appendFormat:@"%02x", digest[i]];
    
    return  outputText;
}

@end
