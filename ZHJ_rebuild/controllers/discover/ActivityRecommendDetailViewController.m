//
//  ActivityRecommendDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRecommendDetailViewController.h"

//cells
#import "ActivityRecommendImageCell.h"
#import "ActivityRecommendInformationCell.h"
#import "ActivityRecommendDetailCell.h"
#import "ActivityRecommendApplyCell.h"

//controllers
#import "ActivityApplyViewController.h"
#import "DisclaimerViewController.h"
#import "FocusPersonFileViewController.h"

@interface ActivityRecommendDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)UIView *footerView;

@end

@implementation ActivityRecommendDetailViewController

#pragma mark - <懒加载>
-(UIView *)footerView
{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
        //没有更多数据
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        label.text = @"没有更多数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = kColorFromRGB(kDeepGray);
        [footerView addSubview:label];
        
        //同城活动免责声明
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, footerView.frame.size.height-40, kSCREEN_WIDTH, 40);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"同城活动免责声明"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [button setAttributedTitle:str forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [footerView addSubview:button];
        
        //button添加事件
        [button addTarget:self action:@selector(jumpToDisclaimerVC) forControlEvents:UIControlEventTouchUpInside];
        
        _footerView = footerView;
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
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

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibImageCell = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendImageCell class]) bundle:nil];
    [self.tableView registerNib:nibImageCell forCellReuseIdentifier:NSStringFromClass([ActivityRecommendImageCell class])];
    
    UINib *nibInfomation = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendInformationCell class]) bundle:nil];
    [self.tableView registerNib:nibInfomation forCellReuseIdentifier:NSStringFromClass([ActivityRecommendInformationCell class])];
    
    UINib *nibDetail = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendDetailCell class]) bundle:nil];
    [self.tableView registerNib:nibDetail forCellReuseIdentifier:NSStringFromClass([ActivityRecommendDetailCell class])];
    
    UINib *nibApply = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendApplyCell class]) bundle:nil];
    [self.tableView registerNib:nibApply forCellReuseIdentifier:NSStringFromClass([ActivityRecommendApplyCell class])];
}

#pragma mark - <跳转同城活动免责声明响应>
-(void)jumpToDisclaimerVC
{
    DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc]initWithNibName:NSStringFromClass([DisclaimerViewController class]) bundle:nil];
    [self.navigationController pushViewController:disclaimerVC animated:YES];
}
#pragma mark - <跳转报名页面>
-(void)jumpToApplyVC
{
    ActivityApplyViewController *applyVC = [[ActivityApplyViewController alloc]initWithNibName:NSStringFromClass([ActivityApplyViewController class]) bundle:nil];
    [self.navigationController pushViewController:applyVC animated:YES];
}
#pragma mark - <跳转个人页面>
-(void)jumpToPersonalFileVC
{
    FocusPersonFileViewController *personalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    [self.navigationController pushViewController:personalFileVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"applyAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToApplyVC];
    }];
}









#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }else if (section == 3) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 80;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 30;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    headerView.backgroundColor = kColorFromRGB(kWhite);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
    label.text = @"报名列表（x）";
    label.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:label];
    if (section == 3) {
        return headerView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return self.footerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        ActivityRecommendImageCell *cellImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendImageCell class])];
        cellImage.labelActivityTitle.text = @"周末狼人杀，嗨起来，Come on！Crazy！！！！！";
        cell = cellImage;
    }else if (indexPath.section == 1){
        ActivityRecommendInformationCell *cellInfomatiom = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendInformationCell class])];
        NSString *strTitle;
        NSString *strContent;
        if (indexPath.row == 0) {
            strTitle = @"活动地点：";
            strContent = @"珠江新城";
        }else if (indexPath.row == 1){
            strTitle = @"活动时间：";
            strContent = @"2017年12月23日-12月30日（每周末都嗨起来，节假日不休息，随治随走，不开刀，无痛苦）";
        }else if (indexPath.row == 2){
            strTitle = @"发起人：";
            strContent = @"xxx";
        }else if (indexPath.row == 3){
            strTitle = @"联系方式：";
            strContent = @"1378947747738";
        }else if (indexPath.row == 4){
            strTitle = @"活动费用：";
            strContent = @"免费";
        }
        cellInfomatiom.labelTitle.text = strTitle;
        cellInfomatiom.labelContent .text = strContent;
        cell = cellInfomatiom;
    }else if (indexPath.section == 2){
        ActivityRecommendDetailCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendDetailCell class])];
        cellDetail.labelDetail.text = @"每周末都嗨起来，节假日不休息，随治随走，不开刀，无痛苦每周末都嗨起来，节假日不休息，随治随走，不开刀，无痛苦每周末都嗨起来，节假日不休息，随治随走，不开刀，无痛苦";
        cell = cellDetail;
    }else if (indexPath.section == 3){
        ActivityRecommendApplyCell *cellApply = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendApplyCell class])];
        cell = cellApply;
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        [self jumpToPersonalFileVC];
    }
}


@end
