//
//  AllClassifyChildrenSecondModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AllClassifyChildrenSecondModel : JSONModel

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *parent_id;
@property (nonatomic, strong)NSString *level;

@end
