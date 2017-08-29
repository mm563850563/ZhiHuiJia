//
//  FocusPersonFileViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "FocusPersonFileViewController.h"

//cells
#import "FocusPersonHeaderCell.h"
#import "FocusPersonCell.h"

//controllers
#import "DynamicDetailViewController.h"
#import "PersonalRankActivityViewController.h"

@interface FocusPersonFileViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FocusPersonFileViewController

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibHeader = [UINib nibWithNibName:NSStringFromClass([FocusPersonHeaderCell class]) bundle:nil];
    [self.tableView registerNib:nibHeader forCellReuseIdentifier:NSStringFromClass([FocusPersonHeaderCell class])];
    
    [self.tableView registerClass:[FocusPersonCell class] forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
}

#pragma mark - <跳转“个人活跃度排名”页面>
-(void)jumpToPersonalRankVC
{
    PersonalRankActivityViewController *personalRankVC = [[PersonalRankActivityViewController alloc]initWithNibName:NSStringFromClass([PersonalRankActivityViewController class]) bundle:nil];
    personalRankVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalRankVC animated:YES];
}

#pragma mark - <响应RAC>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"popFocusPersonHeaderVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickPrivateChat" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"私信");
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickPersonActivitySort" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToPersonalRankVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickOnFocus" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"+关注");
    }];
    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"CheckFocusAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        NS
//    }];
//    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"CheckFansAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        
//    }];
}





#pragma mark - **** UITableViewDataSource,UITableViewDelegate ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }else{
        return 120;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        FocusPersonHeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonHeaderCell class])];
        cell = cellHeader;
    }else{
        FocusPersonCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
        cell = cellNormal;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc]initWithNibName:NSStringFromClass([DynamicDetailViewController class]) bundle:nil];
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
}


@end
