//
//  SubCategate_BrandViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/10.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubCategate_BrandViewController.h"
#import "LeftSideSegmentView.h"
#import "BrandApplyViewController.h"

//tools
#import "UIView+CurrentViewController.h"

//cells
#import "Categate_BrandCollectionCell.h"
#import "CategoryProductNameCell.h"

//views
#import "Categate_Brand_HeaderView.h"

//models
#import "AllBrandModel.h"
#import "AllBrandResultModel.h"
#import "AllBrandGoodsListModel.h"
#import "AllBrandListModel.h"
#import "AllBrandContentModel.h"

@interface SubCategate_BrandViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UIView *brandBGView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *rightCollectionView;
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)NSArray *allBrandResultArray;
@property (nonatomic, strong)NSArray *allBrandListArray;
@property (nonatomic, strong)NSArray *allBrandGoodsListArray;
@property (nonatomic, strong)AllBrandContentModel *modelContent;

@end

@implementation SubCategate_BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorFromRGB(kLightGray);
    
    [self addBrandView];
    [self initLeftSideSegmentView];
    [self initRightContentView];
    [self getAllBrandData];
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

#pragma mark - <获取allBrand数据>
-(void)getAllBrandData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetAllBrand];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            AllBrandModel *model = [[AllBrandModel alloc]initWithDictionary:dataDict error:&error];
            NSLog(@"%@",error.description);
            
            if ([model.code isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                self.allBrandResultArray = model.data.result;
                AllBrandResultModel *modelResult = self.allBrandResultArray[0];
                self.modelContent = modelResult.content;
                self.allBrandListArray = modelResult.content.brand_list;
                self.allBrandGoodsListArray = modelResult.content.goods_list;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.leftTableView reloadData];
                    [self.rightCollectionView reloadData];
                    //默认选中第一个cell
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
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


#pragma mark - <添加“品牌申请入住”和“入驻品牌细则”>
-(void)addBrandView
{
    UIView *brandBGView = [[UIView alloc]init];
    [self.view addSubview:brandBGView];
    brandBGView.backgroundColor = kColorFromRGB(kLightGray);
    brandBGView.layer.cornerRadius = 3;
    brandBGView.layer.masksToBounds = YES;
    [brandBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(38);
    }];
    self.brandBGView = brandBGView;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"品牌申请入驻" forState:UIControlStateNormal];
    [btn1 setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
    [btn1 setBackgroundColor:kColorFromRGB(kWhite)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.brandBGView addSubview:btn1];
    __weak typeof(self) weakSelf = self;
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.right.equalTo(weakSelf.brandBGView.mas_centerX).with.offset(-1);
    }];
    [btn1 addTarget:self action:@selector(btn1ApplyForAdmission:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"入驻品牌细则" forState:UIControlStateNormal];
    [btn2 setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
    [btn2 setBackgroundColor:kColorFromRGB(kWhite)];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.brandBGView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_offset(0);
        make.left.equalTo(btn1.mas_right).with.offset(2);
    }];
    [btn2 addTarget:self action:@selector(btn2RulesOfApply:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <品牌申请入驻按钮响应>
-(void)btn1ApplyForAdmission:(UIButton *)sender
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ApplyForAdmission" object:nil];
    
}


#pragma mark - <入驻品牌细则按钮响应>
-(void)btn2RulesOfApply:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RulesOfApply" object:nil];
}



#pragma mark - <初始化左侧segmentView>
-(void)initLeftSideSegmentView
{
    self.leftTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.leftTableView];
    
    __weak typeof(self) weakSelf = self;
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.brandBGView.mas_bottom);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(110);
    }];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.backgroundColor = kColorFromRGB(kLightGray);
    self.leftTableView.rowHeight = 50;
    
    UINib *nibProductNameCell = [UINib nibWithNibName:NSStringFromClass([CategoryProductNameCell class]) bundle:nil];
    [self.leftTableView registerNib:nibProductNameCell forCellReuseIdentifier:NSStringFromClass([CategoryProductNameCell class])];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - <初始化rightContentView>
-(void)initRightContentView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.rightCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.rightCollectionView.showsVerticalScrollIndicator = NO;
    self.rightCollectionView.backgroundColor = kColorFromRGB(kWhite);
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
    [self.view addSubview:self.rightCollectionView];
    __weak typeof(self) weakSelf = self;
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftTableView.mas_right);
        make.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.brandBGView.mas_bottom).with.offset(10);
    }];
    
    UINib *nibNormalCell = [UINib nibWithNibName:NSStringFromClass([Categate_BrandCollectionCell class]) bundle:nil];
    [self.rightCollectionView registerNib:nibNormalCell forCellWithReuseIdentifier:NSStringFromClass([Categate_BrandCollectionCell class])];
    
    UINib *nibHeaderView = [UINib nibWithNibName:NSStringFromClass([Categate_Brand_HeaderView class]) bundle:nil];
    [self.rightCollectionView registerNib:nibHeaderView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Categate_Brand_HeaderView class])];
}

















#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource ***
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allBrandGoodsListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllBrandGoodsListModel *model = self.allBrandGoodsListArray[indexPath.row];
    Categate_BrandCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Categate_BrandCollectionCell class]) forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    Categate_Brand_HeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Categate_Brand_HeaderView class]) forIndexPath:indexPath];
    view.model = self.modelContent;
    return view;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllBrandGoodsListModel *model = self.allBrandGoodsListArray[indexPath.item];
    NSString *goods_id = model.goods_id;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectHotSalesProductItem" object:goods_id];
}


#pragma mark - *** UICollectionViewDelegateFlowLayout ***
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat headerWidth = kSCREEN_WIDTH-110;
    CGFloat headerHeight = (headerWidth-10)/3.0*2.0 + 100;
    return CGSizeMake(headerWidth, headerHeight);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (kSCREEN_WIDTH-110-20)/3.2;
    CGFloat itemHeight = itemWidth/2.0*3.0;
    return CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - *** UITableViewDelegate,UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allBrandResultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryProductNameCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CategoryProductNameCell class])];
    cell.backgroundColor = kColorFromRGB(kLightGray);
    
    AllBrandResultModel *model = self.allBrandResultArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.labelName.textColor = kColorFromRGB(kThemeYellow);
    }else{
        cell.labelName.textColor = kColorFromRGB(kBlack);
    }
    
    cell.brandResultModel = model;
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllBrandResultModel *modelResult = self.allBrandResultArray[indexPath.row];
    AllBrandContentModel *modelContent = modelResult.content;
    self.allBrandListArray = modelContent.brand_list;
    self.allBrandGoodsListArray = modelContent.goods_list;
    self.modelContent = modelContent;
    //刷新右边tableView 的数据
    [self.rightCollectionView reloadData];
    //右边tableview滚回顶部
    [self.rightCollectionView setScrollsToTop:YES];
}









@end
