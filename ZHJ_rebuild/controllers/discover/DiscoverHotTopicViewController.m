//
//  DiscoverHotTopicViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverHotTopicViewController.h"

//cells
#import "Discover_HotTopicCell.h"

//models
#import "HotTopicListDataModel.h"
#import "HotTopicListResultModel.h"

@interface DiscoverHotTopicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *topicListArray;

@end

@implementation DiscoverHotTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorFromRGB(kWhite);
    
    [self getHotTopicListData];
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)topicListArray
{
    if (_topicListArray) {
        _topicListArray = [NSMutableArray array];
    }
    return _topicListArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取“热门话题”列表>
-(void)getHotTopicListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kTopicList];
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                HotTopicListDataModel *modelData = [[HotTopicListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.topicListArray = [NSMutableArray arrayWithArray:modelData.result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <获取更多“热门话题”列表>
-(void)getMoreHotTopicListData
{
    
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = kSCREEN_WIDTH/2.1;
    CGFloat itemHeight = itemWidth/2.0*3.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);

    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = kColorFromRGB(kLightGray);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Discover_HotTopicCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([Discover_HotTopicCell class])];
}








#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topicListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Discover_HotTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Discover_HotTopicCell class]) forIndexPath:indexPath];
    return cell;
}

@end
