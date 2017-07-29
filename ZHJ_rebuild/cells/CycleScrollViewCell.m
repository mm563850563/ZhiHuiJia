//
//  CycleScrollViewCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CycleScrollViewCell.h"
#import <SDCycleScrollView.h>
#import "IndexCarouselResultModel.h"


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
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.contentView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"chang"]];
        self.cycleScrollView.autoScrollTimeInterval = 3.0;
        self.cycleScrollView.backgroundColor = kColorFromRGB(kWhite);
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


-(void)setCarouselModels:(NSArray *)carouselModels
{
    if (_carouselModels != carouselModels) {
        _carouselModels = carouselModels;
        
        NSMutableArray *imgLinkArray = [NSMutableArray array];
        for (IndexCarouselResultModel *model in _carouselModels) {
            NSString *imgLinkStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.ad_code];
            [imgLinkArray addObject:imgLinkStr];
        }
        self.cycleScrollView.imageURLStringsGroup = imgLinkArray;
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
