//
//  SameTownViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameTownViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//cells
#import "LookAroundCell.h"

//controllers
#import "SameTownTopicViewController.h"
#import "HandpickActivitiesViewController.h"
#import "LookAroundViewController.h"
#import "FocusPersonFileViewController.h"

//替换controllers
#import "DiscoverHotTopicViewController.h"
#import "DiscoverRecommendViewController.h"
#import "TopicDetailViewController.h"

//models
#import "PeopleNearbyDataModel.h"
#import "PeopleNearbyResultModel.h"

@interface SameTownViewController ()<SegmentTapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (weak, nonatomic) IBOutlet UIView *collectionBGView;
@property (weak, nonatomic) IBOutlet UIView *segmentBGView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@property (nonatomic, strong)NSArray *nearbyArray;

@end

@implementation SameTownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getPeopleNearbyDataWithHUD:hud];
    [self initSegmentView];
    [self initFlipView];
    [self settingCollectionView];
    
    [self respondWithRAC];
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

#pragma mark - <获取“附近的人”数据>
-(void)getPeopleNearbyDataWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPeopleNearby];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                PeopleNearbyDataModel *modelData = [[PeopleNearbyDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.nearbyArray = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.collectionView reloadData];
//                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
//                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
//                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
//            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"同城话题",@"精选活动"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.segmentBGView.frame.size.height) withDataArray:array withFont:14];
    self.segmentView.delegate = self;
    [self.segmentBGView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - <跳转“活动推荐”页面>
-(void)jumpToActivityVC
{
    DiscoverRecommendViewController *activityVC = [[DiscoverRecommendViewController alloc]init];
    activityVC.navigationItem.title = @"精选活动";
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark - <跳转“话题详情”页面>
-(void)jumpToTopicDetailVCWithTopicID:(NSString *)topic_id
{
    TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]initWithNibName:NSStringFromClass([TopicDetailViewController class]) bundle:nil];
    topicDetailVC.navigationItem.title = @"话题详情";
    topicDetailVC.topic_id = topic_id;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

#pragma mark - <初始化flipView>
-(void)initFlipView
{
    DiscoverHotTopicViewController *hotTopicVC = [[DiscoverHotTopicViewController alloc]init];
    hotTopicVC.whereReuseFrom = @"SameTownVC";
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:hotTopicVC];
    
#warning ********** 暂时隐藏附近的人 ***********
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREENH_HEIGHT-64) withArray:vcArray];
//    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 190, kSCREEN_WIDTH, kSCREENH_HEIGHT-64-190) withArray:vcArray];
    [self.view addSubview:self.flipView];
}

#pragma mark - <配置collectionView>
-(void)settingCollectionView
{
    self.flowLayout.minimumInteritemSpacing = 0;
    CGFloat itemWidth = self.collectionView.frame.size.width/5.0;
    CGFloat itemHeight = itemWidth/5.0*6.0;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *nibLookAround = [UINib nibWithNibName:NSStringFromClass([LookAroundCell class]) bundle:nil];
    [self.collectionView registerNib:nibLookAround forCellWithReuseIdentifier:NSStringFromClass([LookAroundCell class])];
}


#pragma mark - <点击“附近的人”响应>
- (IBAction)btnLookAroundAction:(UIButton *)sender
{
    LookAroundViewController *lookAroundVC = [[LookAroundViewController alloc]initWithNibName:NSStringFromClass([LookAroundViewController class]) bundle:nil];
    lookAroundVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lookAroundVC animated:YES];
}

#pragma mark - <跳转“好友主页”>
-(void)jumpToPersonalFileVCWithFriendID:(NSString *)friend_user_id
{
    FocusPersonFileViewController *personalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    personalFileVC.friend_user_id = friend_user_id;
    [self.navigationController pushViewController:personalFileVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //跳转同城话题
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToTopicDetailVCFromSameTownVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *topic_id = x.object;
        [self jumpToTopicDetailVCWithTopicID:topic_id];
    }];
}















#pragma mark - **** SegmentTapViewDelegate,FlipTableViewDelegate ****
-(void)selectedIndex:(NSInteger)index
{
    [self.segmentView selectIndex:1];
    
    if (index == 1) {
        [self jumpToActivityVC];
    }
}

#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nearbyArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LookAroundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LookAroundCell class]) forIndexPath:indexPath];
    PeopleNearbyResultModel *modelResult = self.nearbyArray[indexPath.item];
    cell.modelNearbyResult = modelResult;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleNearbyResultModel *modelResult = self.nearbyArray[indexPath.item];
    [self jumpToPersonalFileVCWithFriendID:modelResult.user_id];
}





@end
