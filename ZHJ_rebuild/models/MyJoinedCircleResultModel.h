//
//  MyJoinedCircleResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyJoinedCircleResultModel : JSONModel

@property (nonatomic, strong)NSString *circle_id;
@property (nonatomic, strong)NSString *circle_name;
@property (nonatomic, strong)NSString *logo;
@property (nonatomic, strong)NSString *members_count;

@end