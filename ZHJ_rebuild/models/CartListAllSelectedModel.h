//
//  CartListAllSelectedModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CartListAllSelectedDataModel.h"

@interface CartListAllSelectedModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)CartListAllSelectedDataModel *data;

@end
