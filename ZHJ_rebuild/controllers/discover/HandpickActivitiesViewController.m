//
//  HandpickActivitiesViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HandpickActivitiesViewController.h"

//cells
#import "Discover_RecommendCell.h"

@interface HandpickActivitiesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HandpickActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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


-(void)initTableView
{
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Discover_RecommendCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([Discover_RecommendCell class])];
}







#pragma mark - **** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discover_RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Discover_RecommendCell class])];
    return cell;
}



@end
