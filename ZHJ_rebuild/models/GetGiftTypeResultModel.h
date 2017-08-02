//
//  GetGiftTypeResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetGiftType_gift_typeModel.h"

@protocol GetGiftType_gift_typeModel <NSObject>
@end

@interface GetGiftTypeResultModel : JSONModel

@property (nonatomic, strong)NSArray<GetGiftType_gift_typeModel> *gift_type;
@property (nonatomic, strong)NSString *banner;

@end
