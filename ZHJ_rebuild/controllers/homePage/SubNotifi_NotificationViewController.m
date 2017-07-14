//
//  SubNotifi_NotificationViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/7.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubNotifi_NotificationViewController.h"

//controllers
#import "SubNotification_AnnouncementViewController.h"
#import "SubNotification_DiscountViewController.h"
#import "SubNotification_OtherViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

@interface SubNotifi_NotificationViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmemtView;
@property (nonatomic, strong)FlipTableView *flipTableView;
@property (nonatomic, strong)NSMutableArray *controllersArray;

@end

@implementation SubNotifi_NotificationViewController

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
    
    [self initSegmentView];
    [self initFlipTaleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"公告",@"优惠",@"其他"];
    self.segmemtView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30) withDataArray:array withFont:13];
    self.segmemtView.delegate = self;
    [self.view addSubview:self.segmemtView];
}

#pragma mark - <初始化flipTableView>
-(void)initFlipTaleView
{
    SubNotification_AnnouncementViewController *subNotification_AnnoucementVC = [[SubNotification_AnnouncementViewController alloc]init];
    SubNotification_DiscountViewController *subNotification_DiscountVC = [[SubNotification_DiscountViewController alloc]init];
    SubNotification_OtherViewController *subNotification_OtherVC = [[SubNotification_OtherViewController alloc]init];
    
    [self.controllersArray addObject:subNotification_AnnoucementVC];
    [self.controllersArray addObject:subNotification_DiscountVC];
    [self.controllersArray addObject:subNotification_OtherVC];
    
    self.flipTableView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 30, kSCREEN_WIDTH, self.view.frame.size.height-30) withArray:self.controllersArray];
    self.flipTableView.delegate = self;
    [self.view addSubview:self.flipTableView];
}






#pragma mark - ******** SegmentTapViewDelegate *********
-(void)selectedIndex:(NSInteger)index
{
    [self.flipTableView selectIndex:index];
    
}

#pragma mark - ******* FlipTableViewDelegate *******
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segmemtView selectIndex:index];
}





@end
