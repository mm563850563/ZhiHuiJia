//
//  GetUserPrize_MyPrizeModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GetUserPrize_MyPrizeModel : JSONModel

@property (nonatomic, strong)NSString<Optional> *gift_name;
@property (nonatomic, strong)NSString<Optional> *image;
@property (nonatomic, strong)NSString<Optional> *prize_id;

@end
