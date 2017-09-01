//
//  CommentListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CommentListViewController.h"

//cells
#import "CommentListCell.h"

//models
#import "ProductCommentDataModel.h"
#import "ProductCommentResultModel.h"

@interface CommentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation CommentListViewController

#pragma mark - <dataArray>
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getGoodsCommentData];
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


#pragma mark - <获取“产品评论”数据>
-(void)getGoodsCommentData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGoodsComment];
    NSDictionary *dictParameter = @{@"goods_id":self.goods_id};
    
    //    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSError *error = nil;
                ProductCommentDataModel *modelData = [[ProductCommentDataModel alloc]initWithDictionary:dataDict[@"data"] error:&error];
                for (ProductCommentResultModel *modelResult in modelData.result) {
                    [self.dataArray addObject:modelResult];
                }
//                self.modelResult = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[CommentListCell class] forCellReuseIdentifier:NSStringFromClass([CommentListCell class])];
}












#pragma mark - **** UITableViewDelegate,UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentListCell class])];
    ProductCommentResultModel *modelResult = self.dataArray[indexPath.row];
    cell.modelProductCommentResult = modelResult;;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListCell *cell = [[CommentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CommentListCell class])];
    ProductCommentResultModel *modelResult = self.dataArray[indexPath.row];
    cell.modelProductCommentResult = modelResult;
    return cell.cellHeight;
}



@end
