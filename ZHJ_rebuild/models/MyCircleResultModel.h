//
//  MyCircleResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyCircleUser_infoModel.h"
#import "MyCircleCircle_infoModel.h"

@protocol MyCircleCircle_infoModel <NSObject>
@end

@interface MyCircleResultModel : JSONModel

@property (nonatomic, strong)MyCircleUser_infoModel *user_info;
@property (nonatomic, strong)NSArray<MyCircleCircle_infoModel> *circle_info;
@property (nonatomic, strong)NSString<Optional> *is_more;

@end
