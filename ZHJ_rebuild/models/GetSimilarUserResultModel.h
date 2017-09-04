//
//  GetSimilarUserResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GetSimilarUserResultModel : JSONModel

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *is_attentioned;

@end
