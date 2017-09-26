//
//  ReportTypeViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ReportTypeViewController.h"

//cells
#import "CircleDetailConfigItemCell.h"
#import "CircleDetailConfigQuitCell.h"

//controllers
#import "ActivityReportViewcontroller.h"

@interface ReportTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReportTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
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
    self.tableView.rowHeight = 60;
    
    UINib *nibItem = [UINib nibWithNibName:NSStringFromClass([CircleDetailConfigItemCell class]) bundle:nil];
    [self.tableView registerNib:nibItem forCellReuseIdentifier:NSStringFromClass([CircleDetailConfigItemCell class])];
    
    UINib *nibCancel = [UINib nibWithNibName:NSStringFromClass([CircleDetailConfigQuitCell class]) bundle:nil];
    [self.tableView registerNib:nibCancel forCellReuseIdentifier:NSStringFromClass([CircleDetailConfigQuitCell class])];
}

#pragma mark - <跳转“举报”页面>
-(void)jumpToReportVCWithReportType:(NSString *)report_type
{
    ActivityReportViewcontroller *reportVC = [[ActivityReportViewcontroller alloc]initWithNibName:NSStringFromClass([ActivityReportViewcontroller class]) bundle:nil];
    reportVC.report_type = report_type;
    [self.navigationController pushViewController:reportVC animated:YES];
}








#pragma mark - ***** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 80;
    }else{
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
    label.text = [NSString stringWithFormat:@"请选择投诉举报的原因"];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kColorFromRGB(kDeepGray);
    [headerView addSubview:label];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    NSString *title = [NSString string];
    if (indexPath.row == 5) {
        CircleDetailConfigQuitCell *cellCancel = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailConfigQuitCell class])];
        [cellCancel.btnConfirm setTitle:@"取消" forState:UIControlStateNormal];
        cell = cellCancel;
    }else{
        CircleDetailConfigItemCell *cellItem = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailConfigItemCell class])];
        if (indexPath.row == 0) {
            title = [NSString stringWithFormat:@"色情低俗"];
        }else if (indexPath.row == 1){
            title = [NSString stringWithFormat:@"广告骚扰"];
        }else if (indexPath.row == 2){
            title = [NSString stringWithFormat:@"政治敏感"];
        }else if (indexPath.row == 3){
            title = [NSString stringWithFormat:@"欺诈骗钱"];
        }else if (indexPath.row == 4){
            title = [NSString stringWithFormat:@"违法(暴力恐怖、违禁品等)"];
        }
        cellItem.labelTitle.text = title;
        cell = cellItem;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSString *report_type = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [self jumpToReportVCWithReportType:report_type];
    }
}


@end
