//
//  DiscoverHeaderCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverHeaderCell.h"

#import <SDCycleScrollView.h>
#import "DiscoverBannerResultModel.h"

@interface DiscoverHeaderCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *carouselBGView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@end

@implementation DiscoverHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - <点击圈子响应>
- (IBAction)btnCircleAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickCircleAction" object:nil];
}

#pragma mark - <点击同城响应>
- (IBAction)btnSameTownAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickSameTownAction" object:nil];
}

#pragma mark - <点击地盘响应>
- (IBAction)btnDomainAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickDomainAction" object:nil];
}


-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:self.carouselBGView.bounds];
        _cycleScrollView.delegate = self;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.backgroundColor = kColorFromRGB(kWhite);
        _cycleScrollView.pageDotColor = kColorFromRGB(kThemeYellow);
        _cycleScrollView.placeholderImage = kPlaceholder;
    }
    return _cycleScrollView;
}

-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.cycleScrollView];
}

-(void)setCycleScrollDataArray:(NSArray *)cycleScrollDataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (DiscoverBannerResultModel *model in cycleScrollDataArray) {
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.ad_code];
        [array addObject:imgStr];
    }
    _cycleScrollView.imageURLStringsGroup = array;
}











#pragma mark - *****  ******
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}







@end
