//
//  PriaseTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PriaseTableViewCell.h"

//models
#import "MyCircleDynamicLike_infoModel.h"


@interface PriaseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelLikeCount;
@property (weak, nonatomic) IBOutlet UIView *likeImgBGView;

@end


@implementation PriaseTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLikeArray:(NSArray *)likeArray
{
    _likeArray = likeArray;
    
    for (int i=0; i<likeArray.count; i++) {
        
        //动态添加头像
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.likeImgBGView addSubview:imgView];
        __weak typeof(self) weakSelf = self;
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.labelLikeCount.mas_right).with.offset(10+25*i);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        imgView.layer.cornerRadius = 17.5;
        imgView.layer.masksToBounds = YES;
        
        MyCircleDynamicLike_infoModel *modelLikeInfo = likeArray[i];
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelLikeInfo.headimg];
        NSURL *url = [NSURL URLWithString:imgStr];
        [imgView sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        self.labelLikeCount.text = [NSString stringWithFormat:@"%lu赞",(unsigned long)likeArray.count];
        
        if (i == 7) {
            break;
        }
    }
}




@end
