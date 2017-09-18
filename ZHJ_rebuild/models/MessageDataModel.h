//
//  MessageDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MessageResultModel.h"

@protocol MessageResultModel <NSObject>
@end

@interface MessageDataModel : JSONModel

@property (nonatomic, strong)NSArray<MessageResultModel> *result;

@end
