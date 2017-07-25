//
//  BrandDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandDetailViewController.h"

//cells
#import "BrandDetailHeaderCell.h"
#import "BrandDetailCell.h"

//views
#import "SegmentTapView.h"

@interface BrandDetailViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@end

@implementation BrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
    [self respondWithRAC];
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

#pragma mark - <settingTableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.f;
    
    UINib *nibHeader = [UINib nibWithNibName:NSStringFromClass([BrandDetailHeaderCell class]) bundle:nil];
    [self.tableView registerNib:nibHeader forCellReuseIdentifier:NSStringFromClass([BrandDetailHeaderCell class])];
    
    [self.tableView registerClass:[BrandDetailCell class] forCellReuseIdentifier:NSStringFromClass([BrandDetailCell class])];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"switchFlip_AllProduct_BrandStory" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *indexNum = x.object;
        NSInteger index = [indexNum integerValue];
        [self.segmentView selectIndex:index];
    }];
}












#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section ==0) {
        BrandDetailHeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandDetailHeaderCell class])];
        cellHeader.dataArray = @[@"78"];
        cell = cellHeader;
    }else
    {
        BrandDetailCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandDetailCell class])];
        cellNormal.dataArray = @[@"43"];
        cell = cellNormal;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 0) {
        return 0.1f;
//    }else{
//        return 50;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    NSArray *titles = @[@"全部商品",@"品牌故事"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:headerView.bounds withDataArray:titles withFont:14];
    self.segmentView.delegate = self;
    [headerView addSubview:self.segmentView];
    if (section == 1) {
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 240;
    }else{
        return (kSCREEN_WIDTH*4.5);
    }
}

#pragma mark - *** SegmentTapViewDelegate ****
-(void)selectedIndex:(NSInteger)index
{
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"switchSegment_AllProduct_BrandStory" object:indexNum];
}

@end
