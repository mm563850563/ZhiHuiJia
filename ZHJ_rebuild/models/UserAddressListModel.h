//
//  UserAddressListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserAddressListDataModel.h"

@interface UserAddressListModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)UserAddressListDataModel *data;

@end
