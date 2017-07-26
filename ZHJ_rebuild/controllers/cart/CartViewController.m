//
//  CartViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CartViewController.h"

//views
#import "SSCheckBoxView.h"

//cells
#import "CartProductListCell.h"
#import "YouthColorCell.h"

//controllers
#import "ProductDetailViewController.h"

@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *tableBGView;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBGView;
@property (nonatomic, strong)SSCheckBoxView *checkBox;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingOutlets];
    [self initTableView];
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


#pragma mark - <配置navigationBar>
-(void)settingNavigation
{
//    UIBarButtonItem *btnRight = [UIBarButtonItem alloc]initWithTitle:<#(nullable NSString *)#> style:<#(UIBarButtonItemStyle)#> target:<#(nullable id)#> action:<#(nullable SEL)#>
}


#pragma mark - <outlet>
-(void)settingOutlets
{
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:CGRectZero style:kSSCheckBoxViewStyleGreen checked:YES];
    [self.checkBoxBGView addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(30);
    }];
    
//    self.checkBox.stateChangedBlock = 
}

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.tableBGView.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorFromRGB(kLightGray);
//    self.tableView.allowsMultipleSelection = YES;
    [self.tableBGView addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nibCartProductList = [UINib nibWithNibName:NSStringFromClass([CartProductListCell class]) bundle:nil];
    [self.tableView registerNib:nibCartProductList forCellReuseIdentifier:NSStringFromClass([CartProductListCell class])];
    
    [self.tableView registerClass:[YouthColorCell class] forCellReuseIdentifier:NSStringFromClass([YouthColorCell class])];
}





#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 1000;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        CartProductListCell *cellCartProductList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CartProductListCell class])];
        cell = cellCartProductList;
    }else if (indexPath.section == 1){
        YouthColorCell *cellYouth = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
        cell = cellYouth;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:headerView.bounds];
        imgView.image = [UIImage imageNamed:@"0youLike"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:imgView];
//        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *prductDetaiVC = [[ProductDetailViewController alloc]init];
    
    [self. navigationController pushViewController:prductDetaiVC animated:YES];
}



@end
