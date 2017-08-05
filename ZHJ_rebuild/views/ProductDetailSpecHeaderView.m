//
//  ProductDetailSpecHeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailSpecHeaderView.h"

@interface ProductDetailSpecHeaderView ()

@property (nonatomic, strong)UILabel *label;

@end

@implementation ProductDetailSpecHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:self.bounds];
        self.label.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label];
    }
    return self;
}

-(void)setName:(NSString *)name
{
    if (_name != name) {
        _name = name;
        self.label.text = name;
    }
}

@end
