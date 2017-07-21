//
//  MyFocusViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyFocusViewController.h"

//cells
#import "LookAroundTableCell.h"

@interface MyFocusViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyFocusViewController

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

#pragma mark - <settingTableView>
-(void)settingTableView
{
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LookAroundTableCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([LookAroundTableCell class])];
}





#pragma mark - *** UITableViewDelegate,UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookAroundTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LookAroundTableCell class])];
    return cell;
}


@end
