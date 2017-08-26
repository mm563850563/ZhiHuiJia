//
//  RefuseActivityResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RefuseActivityResultModel : JSONModel

@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *opinion;
@property (nonatomic, strong)NSString *addtime;

@end
