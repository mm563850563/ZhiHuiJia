//
//  ProductCommentDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductCommentResultModel.h"

@protocol ProductCommentResultModel <NSObject>
@end

@interface ProductCommentDataModel : JSONModel

@property (nonatomic, strong)NSArray<ProductCommentResultModel> *result;

@end
