//
//  UserAddressListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserAddressListResultModel.h"

@protocol UserAddressListResultModel <NSObject>
@end

@interface UserAddressListDataModel : JSONModel

@property (nonatomic, strong)NSArray<UserAddressListResultModel> *result;

@end
