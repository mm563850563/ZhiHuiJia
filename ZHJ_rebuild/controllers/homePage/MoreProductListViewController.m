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

@interface MoreProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)LayoutCode layoutCode;
@property (nonatomic, strong)MoreProduct_SortView *sortView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *classifyListResultArray;

@end

@implementation MoreProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认布局为collectionView
    self.layoutCode = CollectionLayout;
    
    if (self.category_id) {
        [self getClassifyListData];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - <获取数据>
-(void)getClassifyListData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    //分类列表
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kClassifyList];
    //参数
    NSDictionary *dictParameter = @{@"category_id":self.category_id};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            [hud hideAnimated:YES afterDelay:1.0];
            NSDictionary *dataDict = (NSDictionary *)response;
            ClassifyListModel *model = [[ClassifyListModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.classifyListResultArray = model.data.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [self.tableView reloadData];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
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
}

#pragma mark - <初始化collectionView>
-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = self.view.frame.size.width/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.1;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
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
}

#pragma mark - <初始化sortView>
-(void)initMoreProduct_SortView
{
    MoreProduct_SortView *sortView = [[[NSBundle mainBundle] loadNibNamed:@"MoreProduct_SortView" owner:self options:nil] firstObject];
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
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"changeLayout" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = (UIButton *)x.object;
        if (button.isSelected == YES) {
            self.layoutCode = TableLayout;
        }else{
            self.layoutCode = CollectionLayout;
        }
        [self changeLayout];
    }];
    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_recommed" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        
//    }];
//    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_newest" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        
//    }];
//    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_salesVolunm" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        
//    }];
//    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_price" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        
//    }];
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
