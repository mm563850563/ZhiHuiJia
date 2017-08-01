//
//  Categate_Brand_HeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Categate_Brand_HeaderView.h"
#import "AllBrandListModel.h"

@implementation Categate_Brand_HeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addButtonIntoArray];
    [self imgHeaderAddInteraction];
}

-(NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(NSMutableArray *)imgBrandArray
{
    if (!_imgBrandArray) {
        _imgBrandArray = [NSMutableArray array];
    }
    return _imgBrandArray;
}

-(void)addButtonIntoArray
{
    [self.buttonArray addObject:self.btnBrand1];
    [self.buttonArray addObject:self.btnBrand2];
    [self.buttonArray addObject:self.btnBrand3];
    
    [self.imgBrandArray addObject:self.imgBrand1];
    [self.imgBrandArray addObject:self.imgBrand2];
    [self.imgBrandArray addObject:self.imgBrand3];
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

-(void)setModel:(AllBrandContentModel *)model
{
//    if (_model != model) {
        _model = model;
        
        NSString *urlStrHeader = [NSString stringWithFormat:@"%@%@",kDomainImage,model.banner];
        NSURL *urlHeader = [NSURL URLWithString:urlStrHeader];
        [self.imgHeader sd_setImageWithURL:urlHeader placeholderImage:kPlaceholder];
        
        for (int i=0; i<model.brand_list.count; i++) {
            UIImageView *imgView = self.imgBrandArray[i];
            UIButton *button = self.buttonArray[i];
            button.hidden = NO;
            AllBrandListModel *modelBrandList = model.brand_list[i];
            NSString *urlstr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelBrandList.logo];
            NSURL *url = [NSURL URLWithString:urlstr];
            [imgView sd_setImageWithURL:url placeholderImage:kPlaceholder];
        }
//    }
}

@end
