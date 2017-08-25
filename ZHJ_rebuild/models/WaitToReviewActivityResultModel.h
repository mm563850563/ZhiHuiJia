//
//  WaitToReviewActivityResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WaitToReviewActivityResultModel : JSONModel

@property (nonatomic, strong)NSString *activity_id;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *start_time;
@property (nonatomic, strong)NSString *end_time;
@property (nonatomic, strong)NSString *image;

@end
