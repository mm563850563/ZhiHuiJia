//
//  MoreProductListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MoreProductListViewController.h"

//cells
#import "MoreProductListCell.h"
#import "MoreProductTableViewCell.h"

//views
#import "MoreProduct_SortView.h"

//controllers
#import "ProductDetailViewController.h"

//models
#import "ClassifyListModel.h"
#import "ClassifyListResultModel.h"

typedef NS_ENUM(NSUInteger,LayoutCode){
    CollectionLayout,//collectionView布局
    TableLayout  //tableView布局
};

@interface MoreProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, assign)LayoutCode layoutCode;
@property (nonatomic, strong)MoreProduct_SortView *sortView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *classifyListResultArray;

@property (nonatomic, strong)UITextField *searchBar;

@property (nonatomic, strong)NSNumber *page;
@property (nonatomic, strong)NSString *sort;

@end

@implementation MoreProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认布局为collectionView
    self.layoutCode = CollectionLayout;
    self.page = @1;
    self.sort = @"recommend";
    
    if (self.category_id) {
        [self getClassifyListDataWithSort:@"recommend" value:nil];
    }else if ([self.whereReuseFrom isEqualToString:@"searchGoods"]){
        [self getSearchGoodsDataWithKeyword:self.keyword sort:@"recommend" value:nil page:@1];
    }
    
    [self settingNavigation];
    [self initMoreProduct_SortView];
    [self initTableView];
    [self initCollectionView];
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <懒加载>
-(NSMutableArray *)classifyListResultArray
{
    if (!_classifyListResultArray) {
        _classifyListResultArray = [NSMutableArray array];
    }
    return _classifyListResultArray;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - <获取“更多商品”数据>
-(void)getClassifyListDataWithSort:(NSString *)sort value:(NSString *)value
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    //分类列表
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kClassifyList];
    //参数
    NSMutableDictionary *dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:self.category_id forKey:@"category_id"];
    [dictParameter setObject:sort forKey:@"sort"];
    
    if (self.is_root) {
        [dictParameter setObject:@"1" forKey:@"is_root"];
    }else{
        [dictParameter setObject:@"0" forKey:@"is_root"];
    }
    
    if (value) {
        [dictParameter setObject:value forKey:@"value"];
    }
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            ClassifyListModel *model = [[ClassifyListModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
//                for (ClassifyListResultModel *modelResult in model.data.result) {
//                    [self.classifyListResultArray addObject:modelResult];
//                }
                self.classifyListResultArray = [NSMutableArray arrayWithArray:model.data.result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [hud hideAnimated:YES afterDelay:1.0];
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

#pragma mark - <获取“搜索商品”数据>
-(void)getSearchGoodsDataWithKeyword:(NSString *)keyword sort:(NSString *)sort value:(NSString *)value page:(NSNumber *)page
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    //分类列表
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSearchGoods];
    //参数
    NSMutableDictionary *dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:keyword forKey:@"keyword"];
    [dictParameter setObject:kUserDefaultObject(kUserInfo) forKey:@"user_id"];
    [dictParameter setObject:sort forKey:@"sort"];
    [dictParameter setObject:self.page forKey:@"page"];
    
//    if (self.is_root) {
//        [dictParameter setObject:@"1" forKey:@"is_root"];
//    }else{
//        [dictParameter setObject:@"0" forKey:@"is_root"];
//    }
    
    if (value) {
        [dictParameter setObject:value forKey:@"value"];
    }
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            ClassifyListModel *model = [[ClassifyListModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                for (ClassifyListResultModel *modelResult in model.data.result) {
                    [self.classifyListResultArray addObject:modelResult];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    int page = [self.page intValue];
                    page++;
                    self.page = [NSNumber numberWithInt:page];
                    
                    [self.collectionView reloadData];
                    [self.tableView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [hud hideAnimated:YES afterDelay:1.0];
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

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(50);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MoreProductTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MoreProductTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
            [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:@"1" page:self.page];
        }else{
            [self getClassifyListDataWithSort:self.sort value:@"1"];
        }
    }];
}

#pragma mark - <初始化collectionView>
-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = self.view.frame.size.width/2.01;
        CGFloat itemHeight = itemWidth/2.0*3.1;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(3, 0, 0, 0);
//        _flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 50);
    }
    return _flowLayout;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([MoreProductListCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class])];
        
        _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
                [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:@"1" page:self.page];
            }else{
                [self getClassifyListDataWithSort:self.sort value:@"1"];
            }
        }];
    }
    return _collectionView;
}
-(void)initCollectionView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(50);
    }];
}


-(void)settingNavigation
{
    self.navigationController.navigationBar.translucent = NO;
    
    [self settingSearchBar];
}

#pragma mark - <配置searchBar>
-(void)settingSearchBar
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
    
//    UISearchBar *searchBar = [[UISearchBar alloc]init];
//    searchBar.delegate = self;
//    UIColor *color = kColorFromRGBAndAlpha(kWhite, 1.0);
//    UIImage *image = [UIImage imageWithColor:color height:30.0];
//    [searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
//    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    searchBar.placeholder = @"请输入关键字";
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

#pragma mark - <搜索按钮响应>
-(void)btnSearchAction:(UIButton *)sender
{
    //释放编辑状态
    [self.searchBar endEditing:YES];
    
    self.keyword = self.searchBar.text;
    
    if (![self.searchBar.text isEqualToString:@""]) {
        self.page = @1;
        [self.classifyListResultArray removeAllObjects];
        if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
            [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:@"1" page:@1];
        }else{
            [self getClassifyListDataWithSort:self.sort value:@"1"];
        }
    }
}

#pragma mark - <初始化sortView>
-(void)initMoreProduct_SortView
{
    MoreProduct_SortView *sortView = [[[NSBundle mainBundle] loadNibNamed:@"MoreProduct_SortView" owner:self options:nil] firstObject];
    sortView.whereReuseFrom = @"moreProductListVC";
    [self.view addSubview:sortView];
    [sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
    self.sortView = sortView;
}

#pragma mark - <页面布局变化>
-(void)changeLayout
{
    if (self.layoutCode == CollectionLayout) {
        [self.view bringSubviewToFront:self.collectionView];
    }else if (self.layoutCode == TableLayout){
        [self.view sendSubviewToBack:self.collectionView];
    }
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //切换布局
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"changeLayoutFromMoreProductVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = (UIButton *)x.object;
        if (button.isSelected == YES) {
            self.layoutCode = TableLayout;
        }else{
            self.layoutCode = CollectionLayout;
        }
        [self changeLayout];
    }];
    
    //按推荐排序
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_recommed" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
        self.sort = @"recommend";
        UIButton *button = x.object;
        NSString *value = [NSString string];
        if (button.selected) {
            value = @"1";
        }else{
            value = @"0";
        }
        
        [self.classifyListResultArray removeAllObjects];
        if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
            [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:value page:@1];
        }else{
            [self getClassifyListDataWithSort:self.sort value:value];
        }
        
    }];
    
    //按最新排序
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_newest" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
        self.sort = @"lastest";
        UIButton *button = x.object;
        NSString *value = [NSString string];
        if (button.selected) {
            value = @"1";
        }else{
            value = @"0";
        }
        
        [self.classifyListResultArray removeAllObjects];
        if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
            [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:value page:@1];
        }else{
            [self getClassifyListDataWithSort:self.sort value:value];
        }
    }];
    
    //按销量排序
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_salesVolunm" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
        self.sort = @"sales";
        UIButton *button = x.object;
        NSString *value = [NSString string];
        if (button.selected) {
            value = @"1";
        }else{
            value = @"0";
        }
        
        [self.classifyListResultArray removeAllObjects];
        if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
            [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:value page:@1];
        }else{
            [self getClassifyListDataWithSort:self.sort value:value];
        }
    }];
    
    //按价格排序
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_price" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
        self.sort = @"price";
        UIButton *button = x.object;
        NSString *value = [NSString string];
        if (button.selected) {
            value = @"1";
        }else{
            value = @"0";
        }
        
        [self.classifyListResultArray removeAllObjects];
        if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
            [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:value page:@1];
        }else{
            [self getClassifyListDataWithSort:self.sort value:value];
        }
        
    }];
}











#pragma mark - ******* UITextFiledDelegate ******
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.keyword = self.searchBar.text;
    self.page = @1;
    [self.classifyListResultArray removeAllObjects];
    if ([self.whereReuseFrom isEqualToString:@"searchGoods"]) {
        [self getSearchGoodsDataWithKeyword:self.keyword sort:self.sort value:@"1" page:@1];
    }else{
        [self getClassifyListDataWithSort:self.sort value:@"1"];
    }
    return YES;
}


#pragma mark - ** UICollectionViewDelegate,UICollectionViewDataSource ***
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.classifyListResultArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyListResultModel *model = self.classifyListResultArray[indexPath.item];
    MoreProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class]) forIndexPath:indexPath];
    cell.modelClassifyList = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyListResultModel *model = self.classifyListResultArray[indexPath.row];
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.goods_id = model.goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}



#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classifyListResultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyListResultModel *model = self.classifyListResultArray[indexPath.item];
    MoreProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreProductTableViewCell class])];
    cell.modelClassifyList = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyListResultModel *model = self.classifyListResultArray[indexPath.row];
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.goods_id = model.goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}


@end
