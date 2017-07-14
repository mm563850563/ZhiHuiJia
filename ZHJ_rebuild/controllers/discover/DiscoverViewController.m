//
//  DiscoverViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverViewController.h"

//cells
#import "DiscoverHeaderCell.h"
#import "DiscoverCell.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *mainTableView;

@end

@implementation DiscoverViewController

#pragma mark - <懒加载>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMianTableView];
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


#pragma mark - <初始化mainTableView>
-(void)initMianTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.mainTableView.estimatedRowHeight = 80.0f;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    UINib *nibHeaderCell = [UINib nibWithNibName:NSStringFromClass([DiscoverHeaderCell class]) bundle:nil];
    [self.mainTableView registerNib:nibHeaderCell forCellReuseIdentifier:NSStringFromClass([DiscoverHeaderCell class])];
    
    UINib *nibDiscoverCell = [UINib nibWithNibName:NSStringFromClass([DiscoverCell class]) bundle:nil];
    [self.mainTableView registerNib:nibDiscoverCell forCellReuseIdentifier:NSStringFromClass([DiscoverCell class])];
}






#pragma mark - ********* UITableViewDelegate,UITableViewDataSource ********


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 320;
    }
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        DiscoverHeaderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverHeaderCell class])];
        cell = cell1;
    }else{
        DiscoverCell *cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverCell class])];
        cell = cell2;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
