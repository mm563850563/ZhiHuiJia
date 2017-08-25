//
//  ActivityDetailResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ActivityDetailResultModel : JSONModel

@property (nonatomic, strong)NSString *activity_id;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *initiator;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *start_time;
@property (nonatomic, strong)NSString *end_time;
@property (nonatomic, strong)NSString *entry_fee;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *disclaimer;
@property (nonatomic, strong)NSString *is_signup;

@end
