//
//  MyCircleUser_infoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyCircleUser_infoModel : JSONModel

@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *total_liveness;
@property (nonatomic, strong)NSString *headimg;

@end
