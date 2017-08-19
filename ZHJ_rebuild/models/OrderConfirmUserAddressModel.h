//
//  OrderConfirmUserAddressModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderConfirmUserAddressModel : JSONModel

@property (nonatomic, strong)NSString *address_id;
@property (nonatomic, strong)NSString<Optional> *consignee;
@property (nonatomic, strong)NSString<Optional> *area;
@property (nonatomic, strong)NSString<Optional> *address;
@property (nonatomic, strong)NSString<Optional> *mobile;
@property (nonatomic, strong)NSString<Optional> *is_default;
@property (nonatomic, strong)NSString<Optional> *province;
@property (nonatomic, strong)NSString<Optional> *city;
@property (nonatomic, strong)NSString<Optional> *district;

@end
