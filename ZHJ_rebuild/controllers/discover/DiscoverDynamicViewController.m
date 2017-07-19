//
//  DiscoverDynamicViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverDynamicViewController.h"

#import "DiscoverDynamicCell.h"

@interface DiscoverDynamicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation DiscoverDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorFromRGB(kLightGray);
    
    [self initTableView];
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

-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    UINib *nibDynamic = [UINib nibWithNibName:NSStringFromClass([DiscoverDynamicCell class]) bundle:nil];
    [self.tableView registerNib:nibDynamic forCellReuseIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
}









#pragma mark - **** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didSelectDynamicItem" object:indexPath];
}


@end
