//
//  MoreProduct_SortView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MoreProduct_SortView.h"

@interface MoreProduct_SortView ()

@property (weak, nonatomic) IBOutlet UILabel *labelRecommend;
@property (weak, nonatomic) IBOutlet UIButton *btnRecommend;

@property (weak, nonatomic) IBOutlet UIButton *btnMostNew;
@property (weak, nonatomic) IBOutlet UILabel *labelMostNew;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSalesVolume;
@property (weak, nonatomic) IBOutlet UILabel *labelSalesVolume;
@property (weak, nonatomic) IBOutlet UIButton *btnSalesVolume;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnPrice;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewLayout;
@property (weak, nonatomic) IBOutlet UIButton *btnLayout;

@end

@implementation MoreProduct_SortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnRecommendAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kThemeYellow);
    self.labelMostNew.textColor = kColorFromRGB(kBlack);
    self.labelSalesVolume.textColor = kColorFromRGB(kBlack);
    self.labelPrice.textColor = kColorFromRGB(kBlack);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_recommed" object:nil];
}
- (IBAction)btnMostNewAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kBlack);
    self.labelMostNew.textColor = kColorFromRGB(kThemeYellow);
    self.labelSalesVolume.textColor = kColorFromRGB(kBlack);
    self.labelPrice.textColor = kColorFromRGB(kBlack);
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_newest" object:sender];
}
- (IBAction)btnSalesVolumeAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kBlack);
    self.labelMostNew.textColor = kColorFromRGB(kBlack);
    self.labelSalesVolume.textColor = kColorFromRGB(kThemeYellow);
    self.labelPrice.textColor = kColorFromRGB(kBlack);
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_salesVolunm" object:sender];
    
    if (sender.selected) {
        self.imgViewSalesVolume.image = [UIImage imageNamed:@"up_yellow"];
    }else{
        self.imgViewSalesVolume.image = [UIImage imageNamed:@"down_yellow"];
    }
}
- (IBAction)btnPriceAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kBlack);
    self.labelMostNew.textColor = kColorFromRGB(kBlack);
    self.labelSalesVolume.textColor = kColorFromRGB(kBlack);
    self.labelPrice.textColor = kColorFromRGB(kThemeYellow);
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_price" object:sender];
    
    if (sender.selected) {
        self.imgViewPrice.image = [UIImage imageNamed:@"up_yellow"];
    }else{
        self.imgViewPrice.image = [UIImage imageNamed:@"down_yellow"];
    }
}
- (IBAction)btnLayoutAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLayout" object:sender];
}


@end
