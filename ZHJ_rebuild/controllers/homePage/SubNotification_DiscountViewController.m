//
//  SubNotification_DiscountViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SubNotification_DiscountViewController.h"

//cells
#import "NULLTableViewCell.h"

@interface SubNotification_DiscountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubNotification_DiscountViewController

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
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
}











#pragma mark - ***** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
    return cellNull;
}

@end
