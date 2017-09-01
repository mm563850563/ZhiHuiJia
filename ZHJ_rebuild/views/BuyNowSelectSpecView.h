//
//  BuyNowSelectSpecView.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyNowSelectSpecView : UIView

@property (weak, nonatomic) IBOutlet UIView *countBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnDecrease;
@property (weak, nonatomic) IBOutlet UIButton *btnIncrease;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *defaultPrice;
@property (nonatomic, strong)NSString *goods_code;

@end
