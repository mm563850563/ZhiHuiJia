//
//  MyAddressViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyAddressViewController.h"

//cells
#import "MyAddressCell.h"

//controllers
#import "MyAddressIncreaseViewController.h"

@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableview];
    
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
-(void)settingTableview
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyAddressCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MyAddressCell class])];
}









- (IBAction)btnIncreaseNewlyAddress:(id)sender
{
    MyAddressIncreaseViewController *myAddressIncreaseVC = [[MyAddressIncreaseViewController alloc]initWithNibName:NSStringFromClass([MyAddressIncreaseViewController class]) bundle:nil];
    [self.navigationController pushViewController:myAddressIncreaseVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //编辑地址
    [[[NSNotificationCenter defaultCenter ]rac_addObserverForName:@"EditAddressAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        MyAddressIncreaseViewController *myAddressIncreaseVC = [[MyAddressIncreaseViewController alloc]initWithNibName:NSStringFromClass([MyAddressIncreaseViewController class]) bundle:nil];
        [self.navigationController pushViewController:myAddressIncreaseVC animated:YES];
    }];
    
    //删除地址
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DeleteAddressAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
}












#pragma mark - *** UItableViewDelegate,UITableViewDataSource  ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAddressCell class])];
    return cell;
}

@end
