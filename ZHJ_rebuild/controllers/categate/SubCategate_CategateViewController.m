//
//  SubCategate_CategateViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/10.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubCategate_CategateViewController.h"

//views
#import "LeftSideSegmentView.h"

//cells
#import "Categate_CategateTableViewCell.h"

@interface SubCategate_CategateViewController ()<LeftSideSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)LeftSideSegmentView *leftSegment;
@property (nonatomic, strong)UITableView *rightTableView;

@end

@implementation SubCategate_CategateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLeftSideSegmentView];
    [self initRightTableViewView];
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





#pragma mark - <初始化左侧segmentView>
-(void)initLeftSideSegmentView
{
    NSArray *array = @[@"123",@"345",@"46465",@"3436",@"8578",@"6345",@"345",@"46465",@"3436",@"8578",@"6345",@"345",@"46465",@"3436",@"8578",@"6345"];
    self.dataArray = array;
    LeftSideSegmentView *leftSegment = [[LeftSideSegmentView alloc]initWithFrame:self.view.bounds dataArray:array];
    leftSegment.delegate = self;
    [self.view addSubview:leftSegment];
    __weak typeof(self) weakSelf = self;
    [leftSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.view);
    }];
    
    self.leftSegment = leftSegment;
}

#pragma mark - <初始化右侧collectionView>
-(void)initRightTableViewView
{
    self.rightTableView = [[UITableView alloc]initWithFrame:self.leftSegment.rightContentView.bounds style:UITableViewStyleGrouped];
    [self.leftSegment.rightContentView addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.backgroundColor = kColorFromRGB(kLightGray);
    
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self.rightTableView registerClass:[Categate_CategateTableViewCell class] forCellReuseIdentifier:NSStringFromClass([Categate_CategateTableViewCell class])];
    
    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test"];
}





#pragma mark - ******** LeftSideSegmentViewDelegate ********
-(void)leftSideSegmentView:(LeftSideSegmentView *)leftSideSegmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.dataArray[indexPath.row]);
}


#pragma mark - ****** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Categate_CategateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Categate_CategateTableViewCell class])];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UITableViewHeaderFooterView *
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 100, 30)];
    headerView.backgroundColor = kColorFromRGB( kLightGray);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
    titleLabel.text = @"我的滑板鞋";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titleLabel];
    
    return headerView;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}

@end
