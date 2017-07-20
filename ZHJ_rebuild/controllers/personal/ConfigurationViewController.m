//
//  ConfigurationViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ConfigurationViewController.h"

//cells
#import "ConfigurationCell.h"
#import "Configuration_ButtonCell.h"

//controllers
#import "PersonalFileViewController.h"
#import "MyAddressViewController.h"
#import "ModifyPasswordViewController.h"

@interface ConfigurationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSString *currentVersion;

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
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

#pragma mark - <获取数据>
-(void)getData
{
    self.dataArray = @[@"编辑个人资料",@"收货地址管理",@"修改密码",@"设置个性主题",@"选择喜欢的品类",@"当前版本",@"关于我们"];
    [self getCurrentVersion];
}

#pragma mark - <获取当前版本号>
-(void)getCurrentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    self.currentVersion = [NSString stringWithFormat:@"v%@",app_build];
}

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColorFromRGB(kLightGray);
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibNormal = [UINib nibWithNibName:NSStringFromClass([ConfigurationCell class]) bundle:nil];
    [self.tableView registerNib:nibNormal forCellReuseIdentifier:NSStringFromClass([ConfigurationCell class])];
    
    UINib *nibButton = [UINib nibWithNibName:NSStringFromClass([Configuration_ButtonCell class]) bundle:nil];
    [self.tableView registerNib:nibButton forCellReuseIdentifier:NSStringFromClass([Configuration_ButtonCell class])];
}




#pragma mark - *** UITableViewDelegate,UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        return 80;
    }
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 7) {
        Configuration_ButtonCell *cellButton = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Configuration_ButtonCell class])];
        cell = cellButton;
    }else{
        ConfigurationCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConfigurationCell class])];
        cellNormal.labelTitle.text = self.dataArray[indexPath.row];
        if (indexPath.row == 5) {
            cellNormal.labelSubTitle.text = self.currentVersion;
        }
        cell = cellNormal;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//编辑个人资料
        PersonalFileViewController *personalFileVC = [[PersonalFileViewController alloc]initWithNibName:NSStringFromClass([PersonalFileViewController class]) bundle:nil];
        [self.navigationController pushViewController:personalFileVC animated:YES];
    }else if (indexPath.row == 1){//管理地址
        MyAddressViewController *myAddressVC = [[MyAddressViewController alloc]initWithNibName:NSStringFromClass([MyAddressViewController class]) bundle:nil];
        myAddressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myAddressVC animated:YES];
    }else if (indexPath.row == 2){//修改密码
        ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc]initWithNibName:NSStringFromClass([ModifyPasswordViewController class]) bundle:nil];
        [self.navigationController pushViewController:modifyPasswordVC animated:YES];
    }
}

@end
