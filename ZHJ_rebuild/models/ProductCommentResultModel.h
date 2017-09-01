//
//  ProductCommentResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductCommentServiceModel.h"

@interface ProductCommentResultModel : JSONModel

@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *comment_id;
@property (nonatomic, strong)NSString *goods_grade;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *add_time;
@property (nonatomic, strong)NSArray *img;
@property (nonatomic, strong)ProductCommentServiceModel *service;

@end
