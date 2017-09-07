//
//  MyCircleHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyCircleHeaderCell.h"

@interface MyCircleHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelLiveness;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;

@end

@implementation MyCircleHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    self.imgViewPortrait.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.imgViewPortrait addGestureRecognizer:tap];
}
                                   
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToFocusPersonalVCByPortraitFromMyCircleVC" object:kUserDefaultObject(kUserInfo)];
}

-(void)setModelUser_info:(MyCircleUser_infoModel *)modelUser_info
{
    _modelUser_info = modelUser_info;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelUser_info.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelNickName.text = modelUser_info.nickname;
    self.labelLiveness.text = [NSString stringWithFormat:@"%@点",modelUser_info.total_liveness];
}














@end
