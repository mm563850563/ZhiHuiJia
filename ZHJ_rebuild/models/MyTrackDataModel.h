//
//  MyTrackDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyTrackResultModel.h"

@protocol MyTrackResultModel <NSObject>
@end

@interface MyTrackDataModel : JSONModel

@property (nonatomic, strong)NSArray<MyTrackResultModel> *result;

@end
