//
//  PersonalInfoResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PersonalInfoResultModel : JSONModel

@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *signature;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *district;

@end
