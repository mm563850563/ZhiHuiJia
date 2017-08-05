//
//  GoodsDetailSpec_ListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodsDetailSpec_ValueModel.h"

@protocol GoodsDetailSpec_ValueModel <NSObject>
@end

@interface GoodsDetailSpec_ListModel : JSONModel

@property (nonatomic, strong)NSString *spec_name;
@property (nonatomic, strong)NSArray<GoodsDetailSpec_ValueModel> *spec_value;
@property (nonatomic, copy)NSString *selectedId;

@end
