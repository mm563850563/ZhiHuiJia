//
//  GetGiftListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetGiftListDataModel.h"

@interface GetGiftListModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)GetGiftListDataModel *data;

@end