//
//  DicoverRecommendViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverRecommendViewController.h"

//cells
#import "Discover_RecommendCell.h"

//models
#import "ActivityListDataModel.h"
#import "ActivityListResultModel.h"
#import "ReleaseActivityViewController.h"
#import "ActivityRecommendDetailViewController.h"

@interface DiscoverRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *activityListArray;

@property (nonatomic, strong)UIView *releaseActivity;

@end

@implementation DiscoverRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getActivityListData];
    [self initTableView];
    [self initReleaseActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)activityListArray
{
    if (!_activityListArray) {
        _activityListArray = [NSMutableArray array];
    }
    return _activityListArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取“活动推荐”数据>
-(void)getActivityListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kActivityList];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                ActivityListDataModel *modelData = [[ActivityListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.activityListArray = [NSMutableArray arrayWithArray:modelData.result];
                
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


#pragma mark - <初始化“发布活动”按钮>
-(void)initReleaseActivity
{
    self.releaseActivity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.view addSubview:self.releaseActivity];
    [self.releaseActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    self.releaseActivity.backgroundColor = kColorFromRGB(kThemeYellow);
    self.releaseActivity.layer.cornerRadius = 30;
    self.releaseActivity.layer.masksToBounds = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.releaseActivity addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.centerX.mas_equalTo(0);
    }];
    imgView.image = [UIImage imageNamed:@"pen"];
    imgView.layer.cornerRadius = 15;
    imgView.layer.masksToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.releaseActivity addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imgView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    label.text = @"发布活动";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = kColorFromRGB(kDeepGray);
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.releaseActivity.bounds;
    [self.releaseActivity addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [button addTarget:self action:@selector(jumpToReleaseActivityVC) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <跳转“发布活动”页面>
-(void)jumpToReleaseActivityVC
{
    ReleaseActivityViewController *releaseActivityVC = [[ReleaseActivityViewController alloc]initWithNibName:NSStringFromClass([ReleaseActivityViewController class]) bundle:nil];
    releaseActivityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:releaseActivityVC animated:YES];
}

#pragma mark - <跳转activityRecommendDetailVC>
-(void)jumpToActivityRecommendDetailVCWithActivityID:(NSString *)activity_id
{
    ActivityRecommendDetailViewController *activityRecommendDetailVC = [[ActivityRecommendDetailViewController alloc]initWithNibName:NSStringFromClass([ActivityRecommendDetailViewController class]) bundle:nil];
    activityRecommendDetailVC.activity_id = activity_id;
    activityRecommendDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityRecommendDetailVC animated:YES];
}

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = kColorFromRGB(kWhite);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Discover_RecommendCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([Discover_RecommendCell class])];
}













#pragma mark - **** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discover_RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Discover_RecommendCell class])];
    ActivityListResultModel *modelResult = self.activityListArray[indexPath.row];
    cell.modelActivityResult = modelResult;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityListResultModel *modelResult = self.activityListArray[indexPath.row];
    [self jumpToActivityRecommendDetailVCWithActivityID:modelResult.activity_id];
}


@end
