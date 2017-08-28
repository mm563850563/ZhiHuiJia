//
//  CircleDetailConfigViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleDetailConfigViewController.h"

//cells
#import "CircleDetailConfigItemCell.h"
#import "CircleDetailConfigQuitCell.h"

@interface CircleDetailConfigViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CircleDetailConfigViewController

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
    
    UINib *nibItem = [UINib nibWithNibName:NSStringFromClass([CircleDetailConfigItemCell class]) bundle:nil];
    [self.tableView registerNib:nibItem forCellReuseIdentifier:NSStringFromClass([CircleDetailConfigItemCell class])];
    
    UINib *nibQuit = [UINib nibWithNibName:NSStringFromClass([CircleDetailConfigQuitCell class]) bundle:nil];
    [self.tableView registerNib:nibQuit forCellReuseIdentifier:NSStringFromClass([CircleDetailConfigQuitCell class])];

}











#pragma mark - ***** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 100;
    }else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 3) {
        CircleDetailConfigQuitCell *cellQuit = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailConfigQuitCell class])];
        cell = cellQuit;
    }else{
        CircleDetailConfigItemCell *cellNormalItem = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailConfigItemCell class])];
        if (indexPath.row == 0) {
            cellNormalItem.labelTitle.text = @"分享圈子";
        }else if (indexPath.row == 1){
            cellNormalItem.labelTitle.text = @"查看全部圈子成员";
        }else if (indexPath.row == 2){
            cellNormalItem.labelTitle.text = @"举报";
        }
        cell = cellNormalItem;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"分享圈子");
    }else if (indexPath.row == 1){
        //查看全部成员
    }else if (indexPath.row == 2){
        //举报
    }else if (indexPath.row == 3){
        //退出圈子
    }
}



@end
