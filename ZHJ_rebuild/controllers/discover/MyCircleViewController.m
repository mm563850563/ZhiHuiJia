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
#import "MoreTableViewCell.h"

//models
#import "MyJoinedCircleDataModel.h"
#import "MyJoinedCircleResultModel.h"

//controllers

@interface MyCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *joinedCircleArray;

@end

@implementation MyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getMyJoinedCircleData];
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

#pragma mark - <获取“已加入圈子”数据>
-(void)getMyJoinedCircleData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyJoinedCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyJoinedCircleDataModel *model = [[MyJoinedCircleDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.joinedCircleArray = model.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

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
    
    UINib *nibMore = [UINib nibWithNibName:NSStringFromClass([MoreTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibMore forCellReuseIdentifier:NSStringFromClass([MoreTableViewCell class])];
}











#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.joinedCircleArray.count > 3) {
            return 5;
        }
        return self.joinedCircleArray.count+1;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 150;
        }else if (indexPath.row == 4){
            return 40;
        }
        return 70;
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
        }else if (indexPath.row == 4){
            MoreTableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreTableViewCell class])];
            cell = cellMore;
        }else{
            JoinedCircleCell *cellJoined = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JoinedCircleCell class])];
            MyJoinedCircleResultModel *modelResult = self.joinedCircleArray[indexPath.row-1];
            cellJoined.modelJoinedCircle = modelResult;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToMoreCircleFromMyCircle" object:@"moreJoined"];
        }
    }
}


@end
