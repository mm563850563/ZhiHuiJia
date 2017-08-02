//
//  GoodsDetailModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodsDetailDataModel.h"

@interface GoodsDetailModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)GoodsDetailDataModel *data;

@end
