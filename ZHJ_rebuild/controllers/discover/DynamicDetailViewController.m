//
//  DynamicDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DynamicDetailViewController.h"

//cells
#import "DynamicWithoutCommentCell.h"
#import "PriaseTableViewCell.h"
#import "CommentTableViewCell.h"

@interface DynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DynamicDetailViewController

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

-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibDynamic = [UINib nibWithNibName:NSStringFromClass([DynamicWithoutCommentCell class]) bundle:nil];
    [self.tableView registerNib:nibDynamic forCellReuseIdentifier:NSStringFromClass([DynamicWithoutCommentCell class])];
    
    UINib *nibPriase = [UINib nibWithNibName:NSStringFromClass([PriaseTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibPriase forCellReuseIdentifier:NSStringFromClass([PriaseTableViewCell class])];
    
    UINib *nibComment = [UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibComment forCellReuseIdentifier:NSStringFromClass([CommentTableViewCell class])];
}







#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (indexPath.section == 0) {
        height = 125;
    }else if (indexPath.section == 1){
        height = 45;
    }else if (indexPath.section == 2){
        height = 100;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10;
    if (section == 0) {
        height = 0.1f;
    }
    if (section == 2) {
        height = 30;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1f;
    if (section == 1) {
        height = 10;
    }
    if (section == 2) {
        height = 30;
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        headerView.backgroundColor = kColorFromRGB(kWhite);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
        [headerView addSubview:label];
        label.text = @"全部评论(--)";
        label.font = [UIFont systemFontOfSize:12];
        
        UIView *line =[[ UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
        line.backgroundColor = kColorFromRGB( kLightGray);
        [headerView addSubview:line];
        return headerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        DynamicWithoutCommentCell *cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DynamicWithoutCommentCell class])];
        cell = cell1;
    }else if (indexPath.section == 1){
        PriaseTableViewCell *cellPriase = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PriaseTableViewCell class])];
        cell = cellPriase;
    }else if (indexPath.section == 2){
        CommentTableViewCell *cellComment = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentTableViewCell class])];
        cell = cellComment;
    }
    return cell;
}

@end
