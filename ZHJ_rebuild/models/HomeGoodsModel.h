//
//  HomeGoodsModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HomeGoodsDataModel.h"

@interface HomeGoodsModel : JSONModel

@property (nonatomic, strong)NSNumber *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)HomeGoodsDataModel *data;

@end
