//
//  AllClassifyModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AllClassifyDataModel.h"

@protocol AllClassifyModel

@end

@interface AllClassifyModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)AllClassifyDataModel *data;

@end
