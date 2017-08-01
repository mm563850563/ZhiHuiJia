//
//  ClassifyListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ClassifyListResultModel : JSONModel

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *market_price;
@property (nonatomic, strong)NSString *img;
@property (nonatomic, strong)NSString *goods_remark;
@property (nonatomic, strong)NSString *comment_count;
@property (nonatomic, strong)NSString *average_score;
@property (nonatomic, strong)NSString *sales_sum;

@end
