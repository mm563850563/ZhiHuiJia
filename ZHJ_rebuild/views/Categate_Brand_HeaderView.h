//
//  Categate_Brand_HeaderView.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllBrandContentModel.h"

@interface Categate_Brand_HeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgBrand1;
@property (weak, nonatomic) IBOutlet UIImageView *imgBrand2;
@property (weak, nonatomic) IBOutlet UIImageView *imgBrand3;
@property (weak, nonatomic) IBOutlet UIButton *btnBrand1;
@property (weak, nonatomic) IBOutlet UIButton *btnBrand2;
@property (weak, nonatomic) IBOutlet UIButton *btnBrand3;
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong)NSMutableArray *imgBrandArray;
@property (nonatomic, strong)AllBrandContentModel *model;

@end
