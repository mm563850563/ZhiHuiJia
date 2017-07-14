//
//  CycleScrollViewCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CycleScrollViewCell.h"
#import "CycleScrollModel.h"
#import <SDCycleScrollView.h>


@interface CycleScrollViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@end


@implementation CycleScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.contentView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"huantu"]];
        self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.cycleScrollView.delegate = self;
        [self.contentView addSubview:self.cycleScrollView];
        __weak typeof(self) weakSelf = self;
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}


//-(SDCycleScrollView *)cycleScrollView
//{
//    if (!_cycleScrollView) {
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.contentView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"huantu"]];
//        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _cycleScrollView.delegate = self;
//        [self.contentView addSubview:_cycleScrollView];
//    }
//    return _cycleScrollView;
//}



-(void)setModel:(CycleScrollModel *)model
{
    if (_model != model) {
        _model = model;
        self.cycleScrollView.localizationImageNamesGroup = model.arrayImage;
    }
}

-(CGFloat)height
{
    return 150;
}



#pragma mark - ******** SDCycleScrollViewDelegate *******
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewCell:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollViewCell:self didSelectItemAtIndex:index];
    }
}

@end
