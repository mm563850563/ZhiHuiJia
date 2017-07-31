//
//  AllBrandListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AllBrandListModel : JSONModel

@property (nonatomic, strong)NSString *brand_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *logo;

@end
