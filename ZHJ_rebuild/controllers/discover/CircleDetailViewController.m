//
//  CircleDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleDetailViewController.h"

//views
#import "CircleDetailHeaderView.h"

//cells
#import "CircleDetailDynamicCell.h"

//models
#import "CircleDetailDataModel.h"
#import "CircleDetailResultModel.h"

//controllers
#import "NewPostViewController.h"
#import "CircleDetailConfigViewController.h"

@interface CircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *NewPostView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)CircleDetailResultModel *modelResult;

@end

@implementation CircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getCircleDetailData];
    [self initNewPostView];
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

#pragma mark - <获取“圈子详情”数据>
-(void)getCircleDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCircleDetail];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"circle_id":self.circle_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                CircleDetailDataModel *modelData = [[CircleDetailDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelResult = modelData.result;
                
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

#pragma mark - <初始化“发帖”按钮>
-(void)initNewPostView
{
    self.NewPostView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.view addSubview:self.NewPostView];
    [self.NewPostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    self.NewPostView.backgroundColor = kColorFromRGB(kThemeYellow);
    self.NewPostView.layer.cornerRadius = 30;
    self.NewPostView.layer.masksToBounds = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.NewPostView addSubview:imgView];
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
    [self.NewPostView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imgView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    label.text = @"发帖";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = kColorFromRGB(kDeepGray);
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.NewPostView.bounds;
    [self.NewPostView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [button addTarget:self action:@selector(jumpToReleaseNewPostVC) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <跳转发布新帖子页面>
-(void)jumpToReleaseNewPostVC
{
    NewPostViewController *newPostVC = [[NewPostViewController alloc]initWithNibName:NSStringFromClass([NewPostViewController class]) bundle:nil];
    newPostVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newPostVC animated:YES];
}

#pragma mark - <跳转“圈子详情设置”页面>
-(void)jumpToCircleDetailConfigVC
{
    CircleDetailConfigViewController *circleDetailConfigVC = [[CircleDetailConfigViewController alloc]initWithNibName:NSStringFromClass([CircleDetailConfigViewController class]) bundle:nil];
    [self.navigationController pushViewController:circleDetailConfigVC animated:YES];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    
    UINib *nibCircleDynamic = [UINib nibWithNibName:NSStringFromClass([CircleDetailDynamicCell class]) bundle:nil];
    [self.tableView registerNib:nibCircleDynamic forCellReuseIdentifier:NSStringFromClass([CircleDetailDynamicCell class])];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //跳转圈子详情设置页面
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToCircleConfigureVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToCircleDetailConfigVC];
    }];
}













#pragma mark - ***** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleDetailDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailDynamicCell class])];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CircleDetailHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CircleDetailHeaderView class]) owner:nil options:nil].lastObject;
    NSArray *signinMenberArray = self.modelResult.signin_members;
    headerView.signinMembersArray = signinMenberArray;
    headerView.modelCircleDetailResult = self.modelResult;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSCREEN_WIDTH+70;
}



@end
