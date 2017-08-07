//
//  BrandDetailModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BrandDetailDataModel.h"

@interface BrandDetailModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)BrandDetailDataModel *data;

@end
