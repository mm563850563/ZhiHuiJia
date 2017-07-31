//
//  IndexCarousel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "IndexCarouselDataModel.h"

@interface IndexCarouselModel : JSONModel

@property (nonatomic, strong)NSNumber *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)IndexCarouselDataModel *data;

@end
