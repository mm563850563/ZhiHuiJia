//
//  PersonalInfoDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PersonalInfoResultModel.h"

@interface PersonalInfoDataModel : JSONModel

@property (nonatomic, strong)PersonalInfoResultModel *result;

@end
