//
//  SameTownTopicViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameTownTopicViewController.h"


//cells
#import "FocusPersonCell.h"

@interface SameTownTopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SameTownTopicViewController

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
    
    UINib *nibDynamic = [UINib nibWithNibName:NSStringFromClass([FocusPersonCell class]) bundle:nil];
    [self.tableView registerNib:nibDynamic forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
}






#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FocusPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
    return cell;
}

@end
