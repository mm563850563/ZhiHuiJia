//
//  IndexCarouselDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "IndexCarouselResultModel.h"

@protocol IndexCarouselResultModel <NSObject>

@end

@interface IndexCarouselDataModel : JSONModel

@property (nonatomic, strong)NSArray<IndexCarouselResultModel> *result;

@end
