//
//  DicoverRecommendViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverRecommendViewController.h"

//cells
#import "Discover_RecommendCell.h"

@interface DiscoverRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation DiscoverRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = kColorFromRGB(kWhite);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Discover_RecommendCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([Discover_RecommendCell class])];
}





#pragma mark - **** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discover_RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Discover_RecommendCell class])];
    return cell;
}


@end
