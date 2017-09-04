//
//  SelectTopicResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SelectTopicResultModel : JSONModel

@property (nonatomic, strong)NSString *topic_id;
@property (nonatomic, strong)NSString *topic_title;

@end
