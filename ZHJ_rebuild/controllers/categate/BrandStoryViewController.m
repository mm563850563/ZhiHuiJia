//
//  BrandStoryViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandStoryViewController.h"

#import "BrandDetail_BrandDetailModel.h"

//cells
#import "BrandStoryCell.h"

@interface BrandStoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BrandStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SettingTableView];
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

-(void)SettingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = self.tableView.frame.size.height;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([BrandStoryCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([BrandStoryCell class])];
}


-(void)setModel:(BrandDetail_BrandDetailModel *)model
{
    if (_model != model) {
        _model = model;
    }
}










#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandStoryCell class])];
    cell.model = self.model;
    return cell;
}



@end
