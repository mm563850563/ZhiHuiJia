//
//  GetGiftListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetGiftList_GiftListModel.h"

@protocol GetGiftList_GiftListModel <NSObject>
@end

@interface GetGiftListResultModel : JSONModel

@property (nonatomic, strong)NSString *banner;
@property (nonatomic, strong)NSString *gift_id;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSArray<GetGiftList_GiftListModel> *gift_list;

@end
