//
//  WaitAuditSignUpDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "WaitAuditSignUpResultModel.h"

@protocol WaitAuditSignUpResultModel <NSObject>
@end

@interface WaitAuditSignUpDataModel : JSONModel

@property (nonatomic, strong)NSArray<WaitAuditSignUpResultModel> *result;

@end
