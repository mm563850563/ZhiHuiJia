//
//  HomeCollectCell3.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectCell3 : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct1;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName1;
@property (weak, nonatomic) IBOutlet UILabel *labelProductIntroduce1;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice1;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice1;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct2;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName2;
@property (weak, nonatomic) IBOutlet UILabel *labelProductIntroduce2;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice2;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice2;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end
