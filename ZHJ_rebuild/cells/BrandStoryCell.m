//
//  BrandStoryCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandStoryCell.h"

#import "BrandDetail_BrandDetailModel.h"

@interface BrandStoryCell ()

@property (weak, nonatomic) IBOutlet UITextView *tvStory;

@end

@implementation BrandStoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BrandDetail_BrandDetailModel *)model
{
    if (_model != model) {
        _model = model;
        self.tvStory.text = model.desc;
    }
}




@end
