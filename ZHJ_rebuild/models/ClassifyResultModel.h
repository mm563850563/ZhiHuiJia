//
//  ClassifyResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ClassifyResultModel : JSONModel

@property (nonatomic, strong)NSString *cat_id;
@property (nonatomic, strong)NSString *cat_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *is_selected;

@end
