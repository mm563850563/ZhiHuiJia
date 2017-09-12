//
//  ShakeResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ShakeResultModel : JSONModel

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *gift_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *prize_id;

@end
