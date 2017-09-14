//
//  NotificationViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/7.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "NotificationViewController.h"

//controllers
#import "SubNotifi_MessageViewController.h"
#import "SubNotifi_NotificationViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

@interface NotificationViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipTableView;
@property (nonatomic, strong)NSMutableArray *controllersArray;

@end

@implementation NotificationViewController

#pragma mark - <懒加载>
-(NSMutableArray *)controllersArray
{
    if (!_controllersArray) {
        _controllersArray = [[NSMutableArray alloc]init];
    }
    return _controllersArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self settingNavigationAndAddSegmentView];
    [self initFlipTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <配置navigation，添加segmnetView>
-(void)settingNavigationAndAddSegmentView
{
    //代替navigationBar的view
    UIView *placeNaviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
    placeNaviView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:placeNaviView];
    
    //返回按钮
    UIButton *btnGoback = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeNaviView addSubview:btnGoback];
    [btnGoback setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btnGoback.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnGoback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [btnGoback addTarget:self action:@selector(btnGobackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //segmentView分段：消息和通知
    NSArray *array = @[@"消息",@"通知"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, placeNaviView.frame.size.height-40, kSCREEN_WIDTH/2.0, 30) withDataArray:array withFont:15];
    self.segmentView.dataArray = array;
//    self.segmentView.backgroundColor = kColorFromRGB(kThemeYellow);
    self.segmentView.textSelectedColor = kColorFromRGB(kBlack);
    self.segmentView.lineColor = kColorFromRGB(kBlack);
    [placeNaviView addSubview:self.segmentView];
    [placeNaviView setBackgroundColor:kColorFromRGB(kThemeYellow)];
    self.segmentView.delegate = self;
    
    CGPoint center = self.segmentView.center;
    center.x = placeNaviView.center.x;
    self.segmentView.center = center;
    [self.segmentView setBackgroundColor:kColorFromRGB(kThemeYellow)];
}

#pragma mark - <添加flipTableView>
-(void)initFlipTableView
{
    SubNotifi_MessageViewController *subNotifi_MessageVC = [[SubNotifi_MessageViewController alloc]init];
    SubNotifi_NotificationViewController *subNotifi_NotificationVC = [[SubNotifi_NotificationViewController alloc]init];
    
    [self.controllersArray addObject:subNotifi_MessageVC];
    [self.controllersArray addObject:subNotifi_NotificationVC];
    
    self.flipTableView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, self.view.frame.size.height-64) withArray:self.controllersArray];
    self.flipTableView.delegate = self;
    [self.view addSubview:self.flipTableView];
}

#pragma mark - <返回按钮响应>
-(void)btnGobackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}








#pragma mark - ******** SegmentTapViewDelegate *********
-(void)selectedIndex:(NSInteger)index
{
    [self.flipTableView selectIndex:index];
    
}

#pragma mark - ******* FlipTableViewDelegate *******
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segmentView selectIndex:index];
}






@end
