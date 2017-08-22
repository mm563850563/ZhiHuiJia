//
//  MyTrackResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyTrackGoodsInfoModel.h"

@protocol MyTrackGoodsInfoModel <NSObject>
@end

@interface MyTrackResultModel : JSONModel

@property (nonatomic, strong)NSString *date;
@property (nonatomic, strong)NSArray<MyTrackGoodsInfoModel> *goods_info;

@end
