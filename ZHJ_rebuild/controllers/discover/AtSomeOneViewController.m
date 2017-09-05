//
//  AtSomeOneViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AtSomeOneViewController.h"

//cells
#import "AtSomeOneCell.h"
#import "NULLTableViewCell.h"
#import "NewPostImageCell.h"

//models
#import "GetSimilarUserDataModel.h"
#import "GetSimilarUserResultModel.h"

@interface AtSomeOneViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *friendsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)NSNumber *page;

@property (nonatomic, strong)UISearchBar *searchBarHomePage;

//用于记录已选择的cell的index
@property (nonatomic, strong)NSMutableArray *selectedArray;

@end

@implementation AtSomeOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    [self settingSearchBar];
    [self settingTableView];
    [self settingCollectionView];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)friendsArray
{
    if (!_friendsArray) {
        _friendsArray = [NSMutableArray array];
    }
    return _friendsArray;
}

-(NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <配置searchBar>
-(void)settingSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    UIColor *color = kColorFromRGBAndAlpha(kWhite, 1.0);
    UIImage *image = [UIImage imageWithColor:color height:30.0];
    [searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"请输入要查找的用户名";
    self.navigationItem.titleView = searchBar;
    self.searchBarHomePage = searchBar;

    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 35, 35);
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSearch addTarget:self action:@selector(btnSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithCustomView:btnSearch];
    self.navigationItem.rightBarButtonItem = barBtnSearch;
}


#pragma mark - <查找好友>
-(void)requestSearchFriendsWithHUD:(MBProgressHUD *)hud page:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSearchFriends];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject( kUserInfo),
                                    @"nickname":self.searchBarHomePage.text,
                                    @"page":page};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                GetSimilarUserDataModel *modelData = [[GetSimilarUserDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (GetSimilarUserResultModel *modelResult in modelData.result) {
                    [self.friendsArray addObject:modelResult];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    for (NSDictionary *dict in self.selectedArray) {
                        NSNumber *indexNum = dict[@"indexSelected"];
                        NSInteger index = [indexNum integerValue];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <搜索按钮响应>
-(void)btnSearchAction:(UIButton *)sender
{
    //释放编辑状态
    [self.searchBarHomePage endEditing:YES];
    
    if (![self.searchBarHomePage.text isEqualToString:@""]) {
        
        [self.friendsArray removeAllObjects];
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [self requestSearchFriendsWithHUD:hud page:@1];
    }
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelection = YES;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([AtSomeOneCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([AtSomeOneCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self requestSearchFriendsWithHUD:nil page:self.page];
    }];
}

#pragma mark - <配置collectionView>
-(void)settingCollectionView
{
    CGFloat itemWidth = 40;
    CGFloat itemHeight = 40;
    
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([NewPostImageCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class])];
    
    
}

#pragma mark - <完成按钮响应>
- (IBAction)btnFinishAction:(UIButton *)sender
{
    if (self.selectedArray.count>0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectAtFriend" object:self.selectedArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //删除已选中要@的人
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"deleteImageFromAtSomeoneVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        NSUInteger tag =  button.tag;
        if (self.selectedArray.count > tag) {
            [self.selectedArray removeObjectAtIndex:tag];
        }
        
        [self.collectionView reloadData];
    }];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.friendsArray.count == 0) {
        return 1;
    }
    return self.friendsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.friendsArray.count == 0) {
        NULLTableViewCell  *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }
    AtSomeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AtSomeOneCell class])];
    GetSimilarUserResultModel *modelResult = self.friendsArray[indexPath.row];
    cell.modelResult = modelResult;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetSimilarUserResultModel *modelResult = self.friendsArray[indexPath.row];
    NSNumber *indexNum = [NSNumber numberWithInteger:indexPath.row];
    
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
    [selectedDict setObject:modelResult.user_id forKey:@"user_id"];
    [selectedDict setObject:modelResult.nickname forKey:@"nickname"];
    [selectedDict setObject:modelResult.headimg forKey:@"headimg"];
    [selectedDict setObject:indexNum forKey:@"indexSelected"];
    
    [self.selectedArray addObject:selectedDict];
    [self.collectionView reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *indexNum = [NSNumber numberWithInteger:indexPath.row];
    
    //操作数组删除时不推荐forin
    [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        NSNumber *temp = dict[@"indexSelected"];
        if ([temp isEqual:indexNum]) {
            [self.selectedArray removeObject:dict];
            *stop = YES;
        }
    }];
    
    [self.collectionView reloadData];
}


#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewPostImageCell *cellImage = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewPostImageCell class]) forIndexPath:indexPath];
    NSDictionary *dict = self.selectedArray[indexPath.row];
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,dict[@"headimg"]];
    NSURL *url = [NSURL URLWithString:imgStr];
    [cellImage.imgView sd_setImageWithURL:url placeholderImage:kPlaceholder];
    cellImage.fromWhere = @"atSomeoneVC";
    cellImage.btnDeleteImage.tag = indexPath.row;
    
    return cellImage;
}


#pragma mark - **** UISearchBarDelegate ****
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self btnSearchAction:nil];
}


@end
