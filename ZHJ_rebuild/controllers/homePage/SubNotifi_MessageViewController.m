//
//  SubNotifi_MessageViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/7.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubNotifi_MessageViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "SubMessage_AboutMeViewController.h"
#import "SubMessage_CommentViewController.h"
#import "SubMessage_LikedViewController.h"
#import "SubMessage_PrivateLetterViewController.h"

@interface SubNotifi_MessageViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipTableView;
@property (nonatomic, strong)NSMutableArray *controllersArray;

@end

@implementation SubNotifi_MessageViewController

#pragma mark - <懒加载>
-(NSMutableArray *)controllersArray
{
    if (!_controllersArray) {
        _controllersArray = [[NSMutableArray alloc]init];
    }
    return _controllersArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSegmentView];
    [self initFlipTableView];
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

#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"评论",@"@我",@"私信",@"点赞"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30) withDataArray:array withFont:13];
    self.segmentView.delegate = self;
    [self.view addSubview:self.segmentView];
}

#pragma mark - <初始化flipTableView>
-(void)initFlipTableView
{
    SubMessage_AboutMeViewController *subMessage_AboutMeViewVC = [[SubMessage_AboutMeViewController alloc]initWithNibName:NSStringFromClass([SubMessage_AboutMeViewController class]) bundle:nil];
    SubMessage_CommentViewController *subMessage_CommentVC = [[SubMessage_CommentViewController alloc]initWithNibName:NSStringFromClass([SubMessage_CommentViewController class]) bundle:nil];
    SubMessage_LikedViewController *subMessage_LikedVC = [[SubMessage_LikedViewController alloc]initWithNibName:NSStringFromClass([SubMessage_LikedViewController class]) bundle:nil];
    SubMessage_PrivateLetterViewController *subMessage_PrivateVC = [[SubMessage_PrivateLetterViewController alloc]initWithNibName:NSStringFromClass([SubMessage_PrivateLetterViewController class]) bundle:nil];
    
    [self.controllersArray addObject:subMessage_CommentVC];
    [self.controllersArray addObject:subMessage_AboutMeViewVC];
    [self.controllersArray addObject:subMessage_PrivateVC];
    [self.controllersArray addObject:subMessage_LikedVC];
    
    self.flipTableView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 30, kSCREEN_WIDTH, self.view.frame.size.height-30) withArray:self.controllersArray];
    self.flipTableView.delegate = self;
    [self.view addSubview:self.flipTableView];
}















#pragma mark - ******** SegmentTapViewDelegate *********
-(void)selectedIndex:(NSInteger)index
{
    [self.flipTableView selectIndex:index];
    
}

#pragma mark - ******* FlipTableViewDelegate *******
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segmentView selectIndex:index];
}



@end
