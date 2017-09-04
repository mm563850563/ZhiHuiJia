//
//  MyFansAndMyFocusDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyFansAndMyFocusResultModel.h"

@protocol MyFansAndMyFocusResultModel <NSObject>
@end

@interface MyFansAndMyFocusDataModel : JSONModel

@property (nonatomic, strong)NSArray<MyFansAndMyFocusResultModel> *result;

@end
