//
//  BrandDetail_BrandDetailModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BrandDetail_BrandDetailModel : JSONModel

@property (nonatomic, strong)NSString *brand_name;
@property (nonatomic, strong)NSString *logo;
@property (nonatomic, strong)NSString *banner;
@property (nonatomic, strong)NSString *desc;

@end
