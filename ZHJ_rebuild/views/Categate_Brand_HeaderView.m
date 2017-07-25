//
//  Categate_Brand_HeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Categate_Brand_HeaderView.h"

@implementation Categate_Brand_HeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self imgHeaderAddInteraction];
}

-(void)imgHeaderAddInteraction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postNotificationWithRAC)];
    [self.imgHeader addGestureRecognizer:tap];
}
-(void)postNotificationWithRAC
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickImgBrandApply" object:nil];
}

- (IBAction)btnBrand1Action:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtnBrand1" object:sender];
}
- (IBAction)btnBrand2Action:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtnBrand2" object:sender];
}
- (IBAction)btnBrand3Action:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtnBrand3" object:sender];
}

@end
