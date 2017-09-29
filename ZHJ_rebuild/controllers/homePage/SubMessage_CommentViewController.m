//
//  SubMessage_CommentViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SubMessage_CommentViewController.h"

//cells
#import "NULLTableViewCell.h"
#import "CommentAndAboutMeCell.h"

//models
#import "MessageDataModel.h"
#import "MessageResultModel.h"

//tools
#import "UIButton+Badge.h"

@interface SubMessage_CommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *commentArray;

@end

@implementation SubMessage_CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getCommentDataWithHUD:hud];
    [self settingTableView];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取评论数据>
-(void)getCommentDataWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetMessage];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"msg_type":@"0"};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MessageDataModel *modelData = [[MessageDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.commentArray = [NSMutableArray arrayWithArray:modelData.result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    UINib *nibComment = [UINib nibWithNibName:NSStringFromClass([CommentAndAboutMeCell class]) bundle:nil];
    [self.tableView registerNib:nibComment forCellReuseIdentifier:NSStringFromClass([CommentAndAboutMeCell class])];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //读取消息后刷新列表
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshNotification_commentListVCAfterReadMessage" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self getCommentDataWithHUD:nil];
    }];
}







#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.commentArray.count==0) {
        return 1;
    }else{
        return  self.commentArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentArray.count==0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }else{
        CommentAndAboutMeCell *cellComment = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentAndAboutMeCell class])];
        MessageResultModel *model = self.commentArray[indexPath.row];
        cellComment.modelMessageResult = model;
        
        return cellComment;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageResultModel *modelResult = self.commentArray[indexPath.row];
    NSDictionary *dict = @{@"data":modelResult,
                           @"index":@"0"};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToDynamicDetailVCFromMainMessageVC" object:dict];
}







@end
