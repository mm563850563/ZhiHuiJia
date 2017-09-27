//
//  SearchTopicOrUserViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SearchTopicOrUserViewController.h"

//models
#import "SearchTopicOrUserDataModel.h"
#import "SearchTopicOrUserResultModel.h"
#import "SearchTopicOrUserTopics_infoModel.h"
#import "SearchTopicOrUserUsers_infoModel.h"

//cells
#import "NULLTableViewCell.h"
#import "SearchTopicCell.h"
#import "SearchUserCell.h"

//controllers
#import "FocusPersonFileViewController.h"
#import "TopicDetailViewController.h"

@interface SearchTopicOrUserViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *topicListUserArray;
@property (nonatomic, strong)NSMutableArray *userListUserArray;
@property (nonatomic, strong)UITextField *searchBar;

@end

@implementation SearchTopicOrUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addSearchBarIntoNavigationBar];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)topicListUserArray
{
    if (!_topicListUserArray) {
        _topicListUserArray = [NSMutableArray array];
    }
    return _topicListUserArray;
}
-(NSMutableArray *)userListUserArray
{
    if (!_userListUserArray) {
        _userListUserArray = [NSMutableArray array];
    }
    return _userListUserArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <添加searchBar到navigationBar>
-(void)addSearchBarIntoNavigationBar
{
    UIView *searchBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-80, 30)];
    searchBGView.backgroundColor = kColorFromRGB(kWhite);
    searchBGView.layer.cornerRadius = 2;
    searchBGView.layer.masksToBounds = YES;
    
    //利用textFiled代替searchBar
    UITextField *searchBar = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, searchBGView.bounds.size.width-5, searchBGView.frame.size.height)];
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:[UIImage imageNamed:@"search"]];
    
    searchBar.leftView = leftView;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.placeholder = @"请输入关键字";
    searchBar.font = [UIFont systemFontOfSize:14];
    searchBar.delegate = self;
    [searchBGView addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    self.navigationItem.titleView = searchBGView;
    self.searchBar = searchBar;
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 35, 35);
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSearch addTarget:self action:@selector(btnSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithCustomView:btnSearch];
    self.navigationItem.rightBarButtonItem = barBtnSearch;
}


#pragma mark - <搜索>
-(void)btnSearchAction:(UIButton *)sender
{
    [self.userListUserArray removeAllObjects];
    [self.topicListUserArray removeAllObjects];
    [self.searchBar resignFirstResponder];
    if ([self.searchBar.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入关键字"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [self requestSearchTopicOrUserWithHUD:hud];
    }
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    UINib *nibTopicList = [UINib nibWithNibName:NSStringFromClass([SearchTopicCell class]) bundle:nil];
    [self.tableView registerNib:nibTopicList forCellReuseIdentifier:NSStringFromClass([SearchTopicCell class])];
    
    UINib *nibUserList = [UINib nibWithNibName:NSStringFromClass([SearchUserCell class]) bundle:nil];
    [self.tableView registerNib:nibUserList forCellReuseIdentifier:NSStringFromClass([SearchUserCell class])];
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                NSInteger page = [self.page integerValue];
//                page++;
//                self.page = [NSNumber numberWithInteger:page];
//                if ([self.moreType isEqualToString:@"moreHot"]) {
//                    [self getMoreHotCircleDataWithHUD:nil];
//                }else if ([self.moreType isEqualToString:@"moreJoined"]){
//                    [self getMoreJoinedCircleDataWithHUD:nil];
//                }
//    }];
}


#pragma mark - <搜索话题或者用户>
-(void)requestSearchTopicOrUserWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSearchTopicOrUser];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"keyword":self.searchBar.text};
    
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                SearchTopicOrUserDataModel *modelData = [[SearchTopicOrUserDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                SearchTopicOrUserResultModel *modelResult = modelData.result;
                
                for (SearchTopicOrUserTopics_infoModel *model in modelResult.topics_info) {
                    [self.topicListUserArray addObject:model];
                }
                
                for (SearchTopicOrUserUsers_infoModel *model in modelResult.users_info) {
                    [self.userListUserArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    NSInteger page = [self.page integerValue];
                    //                    page++;
                    //                    self.page = [NSNumber numberWithInteger:page];
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
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

#pragma mark - <跳转“个人好友”资料>
-(void)jumpToFocusPersonalFileVCWithFriendUserID:(NSString *)friend_user_id
{
    FocusPersonFileViewController *focusPersonalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonalFileVC.friend_user_id = friend_user_id;
//    focusPersonalFileVC.whereReuseFrom = @"circleSigninListVC";
    [self.navigationController pushViewController:focusPersonalFileVC animated:YES];
}

#pragma mark - <跳转“话题详情”页面>
-(void)jumpToTopicDetailVCWithTopicID:(NSString *)topic_id
{
    TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]initWithNibName:NSStringFromClass([TopicDetailViewController class]) bundle:nil];
    topicDetailVC.topic_id = topic_id;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}









#pragma mark - ********UITextFieldDelegate*******
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self btnSearchAction:nil];
    return NO;
}


#pragma mark - ***** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.topicListUserArray.count == 0 && self.userListUserArray.count == 0) {
        return 1;
    }
    NSInteger count = self.topicListUserArray.count+self.userListUserArray.count;
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicListUserArray.count == 0 && self.userListUserArray.count == 0) {
        return self.view.frame.size.height;
    }else{
        NSInteger count = self.topicListUserArray.count+self.userListUserArray.count;
        if (indexPath.row < self.topicListUserArray.count) {
            return 100;
        }else if (self.topicListUserArray.count <= indexPath.row < count){
            return 70;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (self.topicListUserArray.count == 0 && self.userListUserArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }else{
        NSInteger count = self.topicListUserArray.count+self.userListUserArray.count;
        if (indexPath.row < self.topicListUserArray.count) {
            SearchTopicCell *cellTopicList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTopicCell class])];
            SearchTopicOrUserTopics_infoModel *modelTopic_info = self.topicListUserArray[indexPath.row];
            cellTopicList.modelTopic_info = modelTopic_info;
            cell = cellTopicList;
            
        }else if (self.topicListUserArray.count <= indexPath.row < count){
            SearchUserCell *cellUserList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchUserCell class])];
            SearchTopicOrUserUsers_infoModel *modelUser_info = self.userListUserArray[indexPath.row-self.topicListUserArray.count];
            cellUserList.modelUser_info = modelUser_info;
            cell = cellUserList;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicListUserArray.count > 0 || self.userListUserArray.count > 0) {
        NSInteger count = self.topicListUserArray.count+self.userListUserArray.count;
        if (indexPath.row < self.topicListUserArray.count) {
            SearchTopicOrUserTopics_infoModel *modelTopic_info = self.topicListUserArray[indexPath.row];
            [self jumpToTopicDetailVCWithTopicID:modelTopic_info.topic_id];
        }else if (self.topicListUserArray.count <= indexPath.row < count){
            SearchTopicOrUserUsers_infoModel *modelUser_info = self.userListUserArray[indexPath.row-self.topicListUserArray.count];
            [self jumpToFocusPersonalFileVCWithFriendUserID:modelUser_info.user_id];
        }
    }
}







@end
