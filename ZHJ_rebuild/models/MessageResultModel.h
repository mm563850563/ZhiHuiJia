//
//  MessageResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MessageResultModel : JSONModel

@property (nonatomic, strong)NSString<Optional> *message_id;
@property (nonatomic, strong)NSString<Optional> *headimg;
@property (nonatomic, strong)NSString<Optional> *nickname;
@property (nonatomic, strong)NSString<Optional> *talk_id;
@property (nonatomic, strong)NSString<Optional> *is_read;
@property (nonatomic, strong)NSString<Optional> *content;
@property (nonatomic, strong)NSString<Optional> *addtime;
@property (nonatomic, strong)NSString<Optional> *reply_parent_content;

@end
