//
//  ProductDetailViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailViewController.h"

//tools
#import "NSMutableAttributedString+ThroughLine.h"

//views
#import "RatingBar.h"
#import <STPickerArea.h>
#import <SDCycleScrollView.h>
#import "ProductColorAndCountView.h"

//controllers
#import "CommentListViewController.h"

//cells
#import "ProductDetailImageCell.h"

//models
#import "GoodsDetailModel.h"
#import "GoodsDetailImageModel.h"
#import "GoodsDetailContentModel.h"

@interface ProductDetailViewController ()<STPickerAreaDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *starBarBGView;
@property (weak, nonatomic) IBOutlet UIView *cycleScrollBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentCount;

@property (nonatomic, strong)RatingBar *starBar;
@property (nonatomic, strong)STPickerArea *areaPicker;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)ProductColorAndCountView *productMessageView;
@property (nonatomic, strong)UIView *cloudGlassBGView;

@property (nonatomic, strong)GoodsDetailGoodsInfoModel *modelInfo;
@property (nonatomic, strong)NSMutableArray *bannerArray;
@property (nonatomic, strong)NSArray *contentArray;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getGoodsDetailData];
    [self addRatingBar];
    [self addCycleScollView];
    [self settingTableView];
    
    
    [self respondWithRAC];
    [self settingHeightForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取商品详情数据>
-(void)getGoodsDetailData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSDictionary *dictParameter = @{@"goods_id":self.goods_id};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGoodsDetail];
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            GoodsDetailModel *model = [[GoodsDetailModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.modelInfo = model.data.result.goods_info;
                self.contentArray = model.data.result.goods_content;
                for (GoodsDetailImageModel *modelImage in model.data.result.goods_images) {
                    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainImage,modelImage.image_url];
                    [self.bannerArray addObject:str];
                }
                
                [self sendDataToOutlets];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <填outlets数据>
-(void)sendDataToOutlets
{
    //banner
    self.cycleScrollView.imageURLStringsGroup = self.bannerArray;
    //info
    self.labelProductName.text = self.modelInfo.goods_name;
    self.labelRemark.text = self.modelInfo.goods_remark;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",self.modelInfo.price];
    NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:self.modelInfo.market_price font:12];
    self.labelMarketPrice.attributedText = throughLineText;
    self.labelCommentCount.text = [NSString stringWithFormat:@"全部评论（%@）",self.modelInfo.comment_count];
    self.starBar.starNumber = [self.modelInfo.average_score integerValue];
}

#pragma mark - <添加cycleScrollView>
-(void)addCycleScollView
{
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.cycleScrollBGView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"chang"]];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.pageDotColor = kColorFromRGB(kThemeYellow);
    [self.cycleScrollBGView addSubview:self.cycleScrollView];
}

#pragma mark - <添加ratingBar>
-(void)addRatingBar
{
    self.starBar = [[RatingBar alloc]initWithFrame:self.starBarBGView.bounds];
    [self.starBarBGView addSubview:self.starBar];
    self.starBar.starNumber = 3;
    self.starBar.enable = NO;
    [self.starBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProductDetailImageCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([ProductDetailImageCell class])];
}

#pragma mark - <选择送货地点>
- (IBAction)btnSelectArea:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
}

#pragma mark - <收回商品规格view>
-(void)dismissProductMessageView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.productMessageView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 300);
    } completion:^(BOOL finished) {
        [self.cloudGlassBGView removeFromSuperview];
    }];
}

#pragma mark - <选择产品颜色和数量>
- (IBAction)btnSelectProductCountAndCountAction:(UIButton *)sender
{
    self.cloudGlassBGView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.cloudGlassBGView.backgroundColor = kColorFromRGBAndAlpha(kBlack, 0.4);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissProductMessageView)];
    [self.cloudGlassBGView addGestureRecognizer:tap];
    [self.view addSubview:self.cloudGlassBGView];
    
    self.productMessageView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ProductColorAndCountView class]) owner:nil options:nil].lastObject;
    self.productMessageView.frame = CGRectMake(0, self.cloudGlassBGView.frame.size.height, kSCREEN_WIDTH, 300);
    [self.cloudGlassBGView addSubview:self.productMessageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.productMessageView.frame = CGRectMake(0, 300, kSCREEN_WIDTH, 300);
    }];
}

#pragma mark - <查看更多评价>
- (IBAction)btnMoreCommentAction:(UIButton *)sender
{
    CommentListViewController *commentListVC = [[CommentListViewController alloc]initWithNibName:NSStringFromClass([CommentListViewController class]) bundle:nil];
    [self.navigationController pushViewController:commentListVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"removeTheView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.productMessageView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 300);
        } completion:^(BOOL finished) {
            [self.cloudGlassBGView removeFromSuperview];
        }];
    }];
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    [self.tableView layoutIfNeeded];
    self.heightForScrollView.constant = self.tableView.contentSize.height + self.cycleScrollView.frame.size.height + 320;;
}
















#pragma mark - **** STPickerAreaDelegate ****
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSMutableArray *array = [NSMutableArray array];
    if (![province isEqualToString:@""]) {
        [array addObject:province];
    }
    if (![city isEqualToString:@""]){
        [array addObject:city];
    }
    if (![area isEqualToString:@""]){
        [array addObject:area];
    }
    
    NSString *string = province;
    for (int i = 1; i < array.count; i++) {
        string = [string stringByAppendingFormat:@">%@",array[i]];
    }
    self.labelArea.text = string;
}


#pragma mark - ***** SDCycleScrollViewDelegate *****
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailContentModel *model = self.contentArray[indexPath.row];
    ProductDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailImageCell class])];
    cell.model = model;
    [self settingHeightForScrollView];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailContentModel *model = self.contentArray[indexPath.row];
    ProductDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailImageCell class])];
    cell.model = model;
    return cell.cellHeight;
}


@end
