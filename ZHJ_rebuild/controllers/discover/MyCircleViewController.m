//
//  MyCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyCircleViewController.h"

//cells
#import "MyCircleHeaderCell.h"
#import "FocusPersonCell.h"
#import "JoinedCircleCell.h"

@interface MyCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyCircleViewController

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
    
    UINib *nibHeader = [UINib nibWithNibName:NSStringFromClass([MyCircleHeaderCell class]) bundle:nil];
    [self.tableView registerNib:nibHeader forCellReuseIdentifier:NSStringFromClass([MyCircleHeaderCell class])];
    
    UINib *nibFocusDynamic = [UINib nibWithNibName:NSStringFromClass([FocusPersonCell class]) bundle:nil];
    [self.tableView registerNib:nibFocusDynamic forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
    
    UINib *nibJoinCircle = [UINib nibWithNibName:NSStringFromClass([JoinedCircleCell class]) bundle:nil];
    [self.tableView registerNib:nibJoinCircle forCellReuseIdentifier:NSStringFromClass([JoinedCircleCell class])];
}









#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 150;
        }
        return 60;
    }
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 100;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyCircleHeaderCell * cellHeader = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCircleHeaderCell class])];
            cell = cellHeader;
        }else{
            JoinedCircleCell *cellJoined = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JoinedCircleCell class])];
            cell = cellJoined;
        }
        
    }else{
        FocusPersonCell *cellFocusDynamic = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
        cell = cellFocusDynamic;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = kColorFromRGB(kWhite);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        label.text = @"关注圈子动态";
        label.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}




@end
