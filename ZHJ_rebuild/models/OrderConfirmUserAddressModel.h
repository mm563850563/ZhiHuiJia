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
@property (nonatomic, strong)NSString *consignee;
@property (nonatomic, strong)NSString *area;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *is_default;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *district;

@end
