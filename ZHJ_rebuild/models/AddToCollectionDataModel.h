//
//  AddToCollectionDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AddToCollectionResultModel.h"

@protocol AddToCollectionResultModel <NSObject>
@end

@interface AddToCollectionDataModel : JSONModel

@property (nonatomic, strong)NSArray<AddToCollectionResultModel> *result;

@end