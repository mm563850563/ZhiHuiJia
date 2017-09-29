//
//  NotificationViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/7.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "NotificationViewController.h"

//controllers
#import "SubNotifi_MessageViewController.h"
#import "SubNotifi_NotificationViewController.h"
#import "DynamicDetailViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//models
#import "GetUserInfoResultModel.h"
#import "MessageResultModel.h"

//IM
#import "EaseUI.h"
#import "ZHJMessageViewController.h"

@interface NotificationViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipTableView;
@property (nonatomic, strong)NSMutableArray *controllersArray;

@property (nonatomic, strong)GetUserInfoResultModel *modelUserInfoResult;

@end

@implementation NotificationViewController

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
    self.view.backgroundColor = [UIColor whiteColor];

    [self settingNavigationAndAddSegmentView];
    [self initFlipTableView];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <配置navigation，添加segmnetView>
-(void)settingNavigationAndAddSegmentView
{
    //代替navigationBar的view
    UIView *placeNaviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
    placeNaviView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:placeNaviView];
    
    //返回按钮
    UIButton *btnGoback = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeNaviView addSubview:btnGoback];
    [btnGoback setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btnGoback.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnGoback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [btnGoback addTarget:self action:@selector(btnGobackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //segmentView分段：消息和通知
    NSArray *array = @[@"消息",@"通知"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, placeNaviView.frame.size.height-40, kSCREEN_WIDTH/2.0, 30) withDataArray:array withFont:15];
    self.segmentView.dataArray = array;
//    self.segmentView.backgroundColor = kColorFromRGB(kThemeYellow);
    self.segmentView.textSelectedColor = kColorFromRGB(kBlack);
    self.segmentView.lineColor = kColorFromRGB(kBlack);
    [placeNaviView addSubview:self.segmentView];
    [placeNaviView setBackgroundColor:kColorFromRGB(kThemeYellow)];
    self.segmentView.delegate = self;
    
    CGPoint center = self.segmentView.center;
    center.x = placeNaviView.center.x;
    self.segmentView.center = center;
    [self.segmentView setBackgroundColor:kColorFromRGB(kThemeYellow)];
}

#pragma mark - <添加flipTableView>
-(void)initFlipTableView
{
    SubNotifi_MessageViewController *subNotifi_MessageVC = [[SubNotifi_MessageViewController alloc]init];
    SubNotifi_NotificationViewController *subNotifi_NotificationVC = [[SubNotifi_NotificationViewController alloc]init];
    
    [self.controllersArray addObject:subNotifi_MessageVC];
    [self.controllersArray addObject:subNotifi_NotificationVC];
    
    self.flipTableView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, self.view.frame.size.height-64) withArray:self.controllersArray];
    self.flipTableView.delegate = self;
    [self.view addSubview:self.flipTableView];
}

#pragma mark - <返回按钮响应>
-(void)btnGobackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <跳转dynamicDetailVC>
-(void)jumpToDynamicDetailVCWithUserID:(NSString *)user_id talkID:(NSString *)talk_id messageID:(NSString *)message_id index:(NSString *)index
{
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc]initWithNibName:NSStringFromClass([DynamicDetailViewController class]) bundle:nil];
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    dynamicDetailVC.user_id = user_id;
    dynamicDetailVC.talk_id = talk_id;
    dynamicDetailVC.message_id = message_id;
    dynamicDetailVC.index = index;
    dynamicDetailVC.whereReuseFrom = @"notificationVC";
    dynamicDetailVC.navigationItem.title = @"动态详情";
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

#pragma mark - <跳转“私信聊天”页面>
-(void)jumpToSingleChatVCWithModel:(GetUserInfoResultModel *)model
{
    ZHJMessageViewController *singleChatVC = [[ZHJMessageViewController alloc]initWithConversationChatter:model.user_id conversationType:EMConversationTypeChat];
    singleChatVC.delegate = self;
    singleChatVC.dataSource = self;
    singleChatVC.navigationItem.title = model.nickname;
    
    [self.navigationController pushViewController:singleChatVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //跳转“单聊”页面
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToSingleChatVCFromPrivateLetterVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        self.modelUserInfoResult = x.object;
        [self jumpToSingleChatVCWithModel:self.modelUserInfoResult];
    }];
    
    //跳转“动态详情”
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToDynamicDetailVCFromMainMessageVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dict = (NSDictionary *)x.object;
        MessageResultModel *model = (MessageResultModel *)dict[@"data"];
        NSString *index  = (NSString *)dict[@"index"];
        [self jumpToDynamicDetailVCWithUserID:kUserDefaultObject(kUserInfo) talkID:model.talk_id messageID:model.message_id index:index];
    }];
    
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

#pragma mark - **** EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource ****
-(id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        NSString *headimg = kUserDefaultObject(kUserHeadimg);
        model.avatarURLPath = headimg;
        model.nickname = @"";
    }else{
        model.avatarURLPath = self.modelUserInfoResult.headimg;
        model.nickname = @"";
    }
    model.failImageName = @"huantu";
    return model;
}




@end
