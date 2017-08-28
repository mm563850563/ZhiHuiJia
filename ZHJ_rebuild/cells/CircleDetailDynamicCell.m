//
//  CircleDetailDynamicCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleDetailDynamicCell.h"

@interface CircleDetailDynamicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentContent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentCount;

@end

@implementation CircleDetailDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
