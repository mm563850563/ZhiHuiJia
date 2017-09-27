//
//  SearchCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SearchCircleViewController.h"

//cells
#import "NULLTableViewCell.h"
#import "HotCircleCell.h"

//mdoels
#import "SearchCircleDataModel.h"
#import "SearchCircleResultModel.h"

//controllers
#import "CircleDetailViewController.h"

@interface SearchCircleViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *circleListArray;
@property (nonatomic, strong)UITextField *searchBar;

@end

@implementation SearchCircleViewController

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
-(NSMutableArray *)circleListArray
{
    if (!_circleListArray) {
        _circleListArray = [NSMutableArray array];
    }
    return _circleListArray;
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
    [self.circleListArray removeAllObjects];
    [self.searchBar resignFirstResponder];
    if ([self.searchBar.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入关键字"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [self requestSearchCircleWithHUD:hud];
    }
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
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        NSInteger page = [self.page integerValue];
//        page++;
//        self.page = [NSNumber numberWithInteger:page];
//        if ([self.moreType isEqualToString:@"moreHot"]) {
//            [self getMoreHotCircleDataWithHUD:nil];
//        }else if ([self.moreType isEqualToString:@"moreJoined"]){
//            [self getMoreJoinedCircleDataWithHUD:nil];
//        }
//    }];
}

#pragma mark - <搜索圈子>
-(void)requestSearchCircleWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSearchCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"circle_name":self.searchBar.text};
    
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                SearchCircleDataModel *modelData = [[SearchCircleDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (SearchCircleResultModel *model in modelData.result) {
                    [self.circleListArray addObject:model];
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

#pragma mark - <跳转“圈子详情”页面>
-(void)jumpToCircleDetailVCWithCircleID:(NSString *)circle_id
{
    CircleDetailViewController *circleDetailVC = [[CircleDetailViewController alloc]initWithNibName:NSStringFromClass([CircleDetailViewController class]) bundle:nil];
    circleDetailVC.circle_id = circle_id;
    circleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circleDetailVC animated:YES];
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
    if (self.circleListArray.count == 0) {
        return 1;
    }
    return self.circleListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.circleListArray.count == 0) {
        return self.view.frame.size.height;
    }else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.circleListArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }else{
        HotCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCircleCell class])];
        SearchCircleResultModel *model = self.circleListArray[indexPath.row];
        cell.modelSearchCircle = model;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.circleListArray.count > 0) {
        SearchCircleResultModel *model = self.circleListArray[indexPath.row];
        NSString *circle_id = model.circle_id;
        [self jumpToCircleDetailVCWithCircleID:circle_id];
    }
}


@end
