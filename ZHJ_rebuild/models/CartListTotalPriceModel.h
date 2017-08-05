//
//  CartListTotalPriceModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CartListTotalPriceModel : JSONModel

@property (nonatomic, strong)NSString *total_fee;
@property (nonatomic, strong)NSString *cut_fee;
@property (nonatomic, strong)NSString *num;

@end
