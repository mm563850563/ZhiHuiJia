//
//  SelectTopicViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SelectTopicViewController.h"

//cells
#import "SelectTopic_TitleCell.h"
#import "NULLTableViewCell.h"

//models
#import "SelectTopicDataModel.h"
#import "SelectTopicResultModel.h"

//controllers
#import "CreateTopicViewController.h"

@interface SelectTopicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *topicArray;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation SelectTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = @1;
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getTopicListDataWithHUD:hud page:@1];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)topicArray
{
    if (!_topicArray) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取圈子分类数据>
-(void)getTopicListDataWithHUD:(MBProgressHUD *)hud page:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCircleTopic];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject( kUserInfo),
                                    @"circle_id":self.circle_id,
                                    @"page":page};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                SelectTopicDataModel *modelData = [[SelectTopicDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (SelectTopicResultModel *modelResult in modelData.result) {
                    [self.topicArray addObject:modelResult];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nibTopicTitle = [UINib nibWithNibName:NSStringFromClass([SelectTopic_TitleCell class]) bundle:nil];
    [self.tableView registerNib:nibTopicTitle forCellReuseIdentifier:NSStringFromClass([SelectTopic_TitleCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getTopicListDataWithHUD:nil page:self.page];
    }];
}

#pragma mark - <跳转“创建话题”页面>
-(void)jumpToCreateTopicVCWithCircleID:(NSString *)circle_id
{
    CreateTopicViewController *createTopicVC = [[CreateTopicViewController alloc]initWithNibName:NSStringFromClass([CreateTopicViewController class]) bundle:nil];
    createTopicVC.circle_id = circle_id;
    [self.navigationController pushViewController:createTopicVC animated:YES];
}

- (IBAction)btnCreateTopicAction:(UIButton *)sender
{
    [self jumpToCreateTopicVCWithCircleID:self.circle_id];
}







#pragma mark - ***** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.topicArray.count == 0) {
        return 1;
    }
    return self.topicArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicArray.count == 0) {
        NULLTableViewCell  *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }else{
        SelectTopic_TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectTopic_TitleCell class])];
        SelectTopicResultModel *modelResult = self.topicArray[indexPath.row];
        cell.modelSelectTopicResult = modelResult;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicArray.count == 0) {
        return  self.view.frame.size.height - 50;
    }else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicArray.count > 0) {
        SelectTopicResultModel *modelResult = self.topicArray[indexPath.row];
        NSDictionary *dict = @{@"topic_id":modelResult.topic_id,
                               @"topic_title":modelResult.topic_title};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectTopic" object:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}






@end
