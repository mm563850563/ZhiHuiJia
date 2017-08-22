//
//  MoreCycleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MoreCycleViewController.h"

//cells
#import "HotCircleCell.h"
#import "NULLTableViewCell.h"

//models
#import "MyJoinedCircleDataModel.h"
#import "MyJoinedCircleResultModel.h"
#import "GetHotCycleCircleInfoModel.h"

@interface MoreCycleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *joinedCircleArray;
@property (nonatomic, strong)NSMutableArray *hotCircleArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation MoreCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.moreType isEqualToString:@"moreJoined"]) {
        self.page = @1;
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [self getMoreJoinedCircleDataWithHUD:hud];
    }else if ([self.moreType isEqualToString:@"moreHot"]){
        [self getMoreHotCircleData];
    }
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)joinedCircleArray
{
    if (!_joinedCircleArray) {
        _joinedCircleArray = [NSMutableArray array];
    }
    return _joinedCircleArray;
}
-(NSMutableArray *)hotCircleArray
{
    if (!_hotCircleArray) {
        _hotCircleArray = [NSMutableArray array];
    }
    return _hotCircleArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取更多“已加入的圈子”数据>
-(void)getMoreJoinedCircleDataWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyJoinedCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"page_count":@10,
                                    @"page":self.page};
    
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyJoinedCircleDataModel *modelData = [[MyJoinedCircleDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (MyJoinedCircleResultModel *model in modelData.result) {
                    [self.joinedCircleArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
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

#pragma mark - <获取更多热门圈子数据>
-(void)getMoreHotCircleData
{
    
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HotCircleCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([HotCircleCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSInteger page = [self.page integerValue];
        page++;
        self.page = [NSNumber numberWithInteger:page];
        [self getMoreJoinedCircleDataWithHUD:nil];
    }];
}








#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.moreType isEqualToString:@"moreJoined"]) {
        if (self.joinedCircleArray.count == 0) {
            return 1;
        }
        return self.joinedCircleArray.count;
    }else if ([self.moreType isEqualToString:@"moreHot"]){
        if (self.hotCircleArray.count == 0) {
            return 1;
        }
        return self.hotCircleArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotCircleArray.count == 0 || self.joinedCircleArray.count == 0) {
        return self.view.frame.size.height;
    }else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCircleCell class])];
    if (self.joinedCircleArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }else{
        if ([self.moreType isEqualToString:@"moreJoined"]) {
            MyJoinedCircleResultModel *model = self.joinedCircleArray[indexPath.row];
            cell.modelJoinedCircle = model;
        }else if ([self.moreType isEqualToString:@"moreHot"]){
            GetHotCycleCircleInfoModel *model = self.hotCircleArray[indexPath.row];
            cell.modelCircleInfo = model;
        }
    }
    
    return cell;
}




@end
