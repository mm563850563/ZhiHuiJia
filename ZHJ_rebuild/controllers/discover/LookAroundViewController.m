//
//  LookAroundViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LookAroundViewController.h"

//cells
#import "LookAroundTableCell.h"

@interface LookAroundViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LookAroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
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

-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibLookAround = [UINib nibWithNibName:NSStringFromClass([LookAroundTableCell class]) bundle:nil];
    [self.tableView registerNib:nibLookAround forCellReuseIdentifier:NSStringFromClass([LookAroundTableCell class])];
}
















#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookAroundTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LookAroundTableCell class])];
    return cell;
}






@end
