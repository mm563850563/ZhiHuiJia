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
@property (weak, nonatomic) IBOutlet UIImageView *imgViewMostNew;

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

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self settingOutlets];
}

-(void)settingOutlets
{
    self.imgViewPrice.tag = 0;
    self.imgViewMostNew.tag = 0;
    self.imgViewSalesVolume.tag = 0;
}


- (IBAction)btnRecommendAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kThemeYellow);
    self.labelMostNew.textColor = kColorFromRGB(kBlack);
    self.labelSalesVolume.textColor = kColorFromRGB(kBlack);
    self.labelPrice.textColor = kColorFromRGB(kBlack);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_recommed" object:nil];
    
    [self rotationUpToDownWithImageView:self.imgViewMostNew];
    [self rotationUpToDownWithImageView:self.imgViewSalesVolume];
    [self rotationUpToDownWithImageView:self.imgViewPrice];
    
    self.btnPrice.selected = NO;
    self.btnMostNew.selected = NO;
    self.btnSalesVolume.selected = NO;
}
- (IBAction)btnMostNewAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kBlack);
    self.labelMostNew.textColor = kColorFromRGB(kThemeYellow);
    self.labelSalesVolume.textColor = kColorFromRGB(kBlack);
    self.labelPrice.textColor = kColorFromRGB(kBlack);
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_newest" object:sender];
    
    [self rotationUpToDownWithImageView:self.imgViewPrice];
    [self rotationUpToDownWithImageView:self.imgViewSalesVolume];
    self.btnPrice.selected = NO;
    self.btnSalesVolume.selected = NO;
    
    if (sender.selected) {
        [self rotationDownToUpWithImageView:self.imgViewMostNew];
    }else{
        [self rotationUpToDownWithImageView:self.imgViewMostNew];
    }
}
- (IBAction)btnSalesVolumeAction:(UIButton *)sender
{
    self.labelRecommend.textColor = kColorFromRGB(kBlack);
    self.labelMostNew.textColor = kColorFromRGB(kBlack);
    self.labelSalesVolume.textColor = kColorFromRGB(kThemeYellow);
    self.labelPrice.textColor = kColorFromRGB(kBlack);
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sort_salesVolunm" object:sender];
    
    [self rotationUpToDownWithImageView:self.imgViewMostNew];
    [self rotationUpToDownWithImageView:self.imgViewPrice];
    self.btnMostNew.selected = NO;
    self.btnPrice.selected = NO;
    
    if (sender.selected) {
        [self rotationDownToUpWithImageView:self.imgViewSalesVolume];
    }else{
        [self rotationUpToDownWithImageView:self.imgViewSalesVolume];
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
    
    [self rotationUpToDownWithImageView:self.imgViewMostNew];
    [self rotationUpToDownWithImageView:self.imgViewSalesVolume];
    self.btnMostNew.selected = NO;
    self.btnSalesVolume.selected = NO;
    
    if (sender.selected) {
        [self rotationDownToUpWithImageView:self.imgViewPrice];
    }else{
        [self rotationUpToDownWithImageView:self.imgViewPrice];
    }
}
- (IBAction)btnLayoutAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.imgViewLayout.image = [UIImage imageNamed:@"layout_tableView"];
    }else{
        self.imgViewLayout.image = [UIImage imageNamed:@"layout_collectionView"];
    }
    NSString *notifiName = [NSString string];
    if ([self.whereReuseFrom isEqualToString:@"moreProductListVC"]) {
        notifiName = @"changeLayoutFromMoreProductVC";
    }else if ([self.whereReuseFrom isEqualToString:@"AllProductVC"]){
        notifiName = @"changeLayoutFromAllProductVC";
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:sender];
}





#pragma mark - <箭头旋转-由下向上>
-(void)rotationDownToUpWithImageView:(UIImageView *)imgView
{
    if (imgView.tag == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
            [imgView setTransform:transform];
        } completion:^(BOOL finished) {
            imgView.tag = 1;
        }];
    }
}

#pragma mark - <箭头旋转-由上向下>
-(void)rotationUpToDownWithImageView:(UIImageView *)imgView
{
    if (imgView.tag == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            imgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            imgView.tag = 0;
        }];
    }
}


@end
