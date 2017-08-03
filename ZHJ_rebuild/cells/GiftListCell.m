//
//  GiftListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "GiftListCell.h"
#import "GetGiftList_GiftListModel.h"

@interface GiftListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgGift;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsWinPrizes;
@property (weak, nonatomic) IBOutlet UILabel *labelGiftName;

@end

@implementation GiftListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(GetGiftList_GiftListModel *)model
{
    if (_model != model) {
        _model = model;
        self.labelGiftName.text = model.gift_name;
        
        NSString *strGift = [NSString stringWithFormat:@"%@%@",kDomainImage,model.image];
        NSURL *url = [NSURL URLWithString:strGift];
        [self.imgGift sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        //显示已中奖
        if ([model.id isEqualToString:self.winGiftID]) {
            self.imgIsWinPrizes.hidden = NO;
        }
    }
}

@end
