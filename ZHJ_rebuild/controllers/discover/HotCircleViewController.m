//
//  HotCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HotCircleViewController.h"

//cells
#import "HotCircleCell.h"

//models
#import "GetHotCycleDataModel.h"
#import "GetHotCycleResultModel.h"

//controllers
#import "MoreCycleViewController.h"

@interface HotCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *circleClassifyArray;

@end

@implementation HotCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getHotCircleData];
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

#pragma mark - <获取热门圈子数据>
-(void)getHotCircleData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetHotCircle];
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                [hud hideAnimated:YES afterDelay:1.0];
                GetHotCycleDataModel *modelData = [[GetHotCycleDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.circleClassifyArray = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorFromRGB(kLightGray);
    self.tableView.rowHeight = 70;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HotCircleCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([HotCircleCell class])];
}

#pragma mark - <“更多>”按钮响应>
-(void)btnMoreActionWithButton:(UIButton *)button
{
    NSInteger tag = button.tag;
    GetHotCycleResultModel *modelResult = self.circleClassifyArray[tag];
    NSDictionary *dict = @{@"classify_id":modelResult.classify_id,
                           @"moreType":@"moreHot",
                           @"classify_name":modelResult.classify_name};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToMoreHotCircle" object:dict];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.circleClassifyArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GetHotCycleResultModel *modelResult = self.circleClassifyArray[section];
    NSArray *array = modelResult.circle_info;
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GetHotCycleResultModel *modelResult = self.circleClassifyArray[section];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 35)];
    headerView.backgroundColor = kColorFromRGB(kWhite);
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width/2, headerView.frame.size.height)];
    label1.text = modelResult.classify_name;
    label1.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label1];
    
    //button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(headerView.frame.size.width-60, 0, 50, headerView.frame.size.height);
    [button setTitle:@"更多>" forState:UIControlStateNormal];
    [button setTitleColor:kColorFromRGB( kBlack) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.tag = section;
    [button addTarget:self action:@selector(btnMoreActionWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [headerView addSubview:button];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetHotCycleResultModel *modelResult = self.circleClassifyArray[indexPath.section];
    GetHotCycleCircleInfoModel *modelCircleInfo = modelResult.circle_info[indexPath.row];
    
    HotCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCircleCell class])];
    cell.modelCircleInfo = modelCircleInfo;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetHotCycleResultModel *modelResult = self.circleClassifyArray[indexPath.section];
    GetHotCycleCircleInfoModel *modelCircleInfo = modelResult.circle_info[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToCircleDetailVC" object:modelCircleInfo.circle_id];
}


@end
