//
//  AllProductViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AllProductViewController.h"

//views
#import "MoreProduct_SortView.h"

//cells
#import "MoreProductListCell.h"
#import "MoreProductTableViewCell.h"

//models
#import "BrandDetail_BrandGoodsModel.h"

//controllers
#import "ProductDetailViewController.h"

typedef NS_ENUM(NSUInteger,LayoutCode){
    CollectionLayout,//collectionView布局
    TableLayout  //tableView布局
};

@interface AllProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)LayoutCode layoutCode;
@property (nonatomic, strong)MoreProduct_SortView *sortView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation AllProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认布局为collectionView
    self.layoutCode = CollectionLayout;
    
    
    [self initTableView];
    [self setUI];
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - <懒加载>
-(MoreProduct_SortView *)sortView
{
    if (!_sortView) {
        _sortView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MoreProduct_SortView class]) owner:nil options:nil].lastObject;
        _sortView.whereReuseFrom = @"AllProductVC";
    }
    return _sortView;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = kSCREEN_WIDTH/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.1;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
        _collectionView.scrollEnabled = NO;
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([MoreProductListCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class])];
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(40);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MoreProductTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MoreProductTableViewCell class])];
}

#pragma mark - <setUI>
-(void)setUI
{
    [self.view addSubview:self.sortView];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(40);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.sortView.mas_bottom).with.offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

-(void)setDataArray:(NSArray *)dataArray
{
    
    _dataArray = dataArray;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    CGFloat itemWidth = kSCREEN_WIDTH/2.02;
    CGFloat itemHeight = itemWidth/2.0*3.0;
    if (itemHeight > (itemWidth+100)) {
        itemHeight = itemWidth+100;
    }
    
    NSInteger lineCount = _dataArray.count/2;
    if (self.dataArray.count%2 != 0) {
        lineCount++;
    }
    CGFloat cellHeight = itemHeight*lineCount + (lineCount+1)*10 + 50;
    NSNumber *object = [NSNumber numberWithFloat:cellHeight];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"settingCellHeightByBrandDetail" object:object];
    
}

#pragma mark - <页面布局变化>
-(void)changeLayout
{
    if (self.layoutCode == CollectionLayout) {
        CGFloat cellHeight = 120*self.dataArray.count;
        NSNumber *object = [NSNumber numberWithFloat:cellHeight];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"settingCellHeightByBrandDetail" object:object];
        
        [self.view bringSubviewToFront:self.collectionView];
    }else if (self.layoutCode == TableLayout){
        CGFloat itemWidth = kSCREEN_WIDTH/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.0;
        if (itemHeight > (itemWidth+100)) {
            itemHeight = itemWidth+100;
        }
        
        NSInteger lineCount = _dataArray.count/2;
        if (self.dataArray.count%2 != 0) {
            lineCount++;
        }
        CGFloat cellHeight = itemHeight*lineCount + (lineCount+1)*10 + 50;
        NSNumber *object = [NSNumber numberWithFloat:cellHeight];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"settingCellHeightByBrandDetail" object:object];
        
        [self.view sendSubviewToBack:self.collectionView];
    }
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //切换布局
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"changeLayoutFromAllProductVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = (UIButton *)x.object;
        if (button.isSelected == YES) {
            self.layoutCode = TableLayout;
        }else{
            self.layoutCode = CollectionLayout;
        }
        [self changeLayout];
    }];
}











#pragma mark - ** UICollectionViewDelegate,UICollectionViewDataSource ***
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetail_BrandGoodsModel *model = self.dataArray[indexPath.item];
    MoreProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class]) forIndexPath:indexPath];
    cell.modelBrandGoods = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}




#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetail_BrandGoodsModel *model = self.dataArray[indexPath.item];
    MoreProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreProductTableViewCell class])];
    cell.modelBrandGoods = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BrandDetail_BrandGoodsModel *model = self.dataArray[indexPath.item];
//    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
//    productDetailVC.goods_id = model.goods_id;
//    [self.navigationController pushViewController:productDetailVC animated:YES];
}



@end
