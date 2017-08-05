//
//  CartListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CartListDataModel.h"

@interface CartListModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)CartListDataModel *data;

@end
