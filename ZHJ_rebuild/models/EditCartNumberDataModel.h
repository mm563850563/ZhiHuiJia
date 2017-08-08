//
//  EditCartNumberDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "EditCartNumberResultModel.h"

@interface EditCartNumberDataModel : JSONModel

@property (nonatomic, strong)EditCartNumberResultModel *result;

@end
