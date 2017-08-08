//
//  EditCartNumberResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface EditCartNumberResultModel : JSONModel

@property (nonatomic, strong)NSString *is_success;
@property (nonatomic, strong)NSString *total_price;

@end
