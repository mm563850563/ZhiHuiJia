//
//  SameHobbyPersonListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameHobbyPersonListViewController.h"

//cells
#import "SameHobbyPersonListCell.h"

//controllers
#import "FocusPersonFileViewController.h"

@interface SameHobbyPersonListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SameHobbyPersonListViewController

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

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SameHobbyPersonListCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([SameHobbyPersonListCell class])];
}









#pragma mark - ***** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SameHobbyPersonListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SameHobbyPersonListCell class])];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FocusPersonFileViewController *sameHobbyPersonVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    [self.navigationController pushViewController:sameHobbyPersonVC animated:YES];
}





@end
