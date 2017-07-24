//
//  ProductDetailViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailViewController.h"

//views
#import "RatingBar.h"
#import <STPickerArea.h>
#import <SDCycleScrollView.h>
#import "ProductColorAndCountView.h"

//controllers
#import "CommentListViewController.h"

@interface ProductDetailViewController ()<STPickerAreaDelegate,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *starBarBGView;
@property (weak, nonatomic) IBOutlet UIView *cycleScrollBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;

@property (nonatomic, strong)RatingBar *starBar;
@property (nonatomic, strong)STPickerArea *areaPicker;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)ProductColorAndCountView *productMessageView;
@property (nonatomic, strong)UIView *cloudGlassBGView;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRatingBar];
    [self addCycleScollView];
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

#pragma mark - <添加cycleScrollView>
-(void)addCycleScollView
{
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.cycleScrollBGView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"chang"]];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    UIImage *img1 = [UIImage imageNamed:@"fxdl"];
    UIImage *img2 = [UIImage imageNamed:@"fenxiangdali"];
    UIImage *img3 = [UIImage imageNamed:@"tongzzhi2"];
    NSArray *imgArray = @[img1,img2,img3];
    self.cycleScrollView.localizationImageNamesGroup = imgArray;
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

#pragma mark - <选择送货地点>
- (IBAction)btnSelectArea:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
}

#pragma mark - <选择产品颜色和数量>
- (IBAction)btnSelectProductCountAndCountAction:(UIButton *)sender
{
    self.cloudGlassBGView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.cloudGlassBGView.backgroundColor = kColorFromRGBAndAlpha(kBlack, 0.4);
    [self.view addSubview:self.cloudGlassBGView];
    
    self.productMessageView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ProductColorAndCountView class]) owner:nil options:nil].lastObject;
    [self.cloudGlassBGView addSubview:self.productMessageView];
    [self.productMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cloudGlassBGView.mas_bottom).with.offset(-330);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    
    [UIView animateWithDuration:2 animations:^{
        
        [self.productMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
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
//        CGRect frame = self.productMessageView.frame;
//        frame.size.height = 0;
//        self.productMessageView.frame = frame;
        [self.cloudGlassBGView removeFromSuperview];
    }];
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

@end
