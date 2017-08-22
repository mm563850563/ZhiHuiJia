//
//  MyCollectionListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyCollectionListResultModel.h"

@protocol MyCollectionListResultModel <NSObject>
@end

@interface MyCollectionListDataModel : JSONModel

@property (nonatomic, strong)NSArray<MyCollectionListResultModel> *result;

@end
