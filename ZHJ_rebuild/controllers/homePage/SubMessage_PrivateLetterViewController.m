//
//  SubMessage_PrivateLetterViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SubMessage_PrivateLetterViewController.h"

//tools
#import "UIButton+Badge.h"

//models
#import "GetUserInfoDataModel.h"
#import "GetUserInfoResultModel.h"

//cells
#import "NULLTableViewCell.h"
#import "PrivateLetterCell.h"

//IM
#import "EaseUI.h"
#import "ZHJMessageViewController.h"

@interface SubMessage_PrivateLetterViewController ()<UITableViewDelegate,UITableViewDataSource,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *privateLetterArray;
@property (nonatomic, strong)NSMutableArray *conversationArray;
@property (nonatomic, strong)NSMutableArray *userIDArray;

@end

@implementation SubMessage_PrivateLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
    MBProgressHUD *hud = [ProgressHUDManager showFullScreenProgressHUDAddTo:self.view animated:YES];
    [self getConversationDataWithHUD:hud];
    
    //添加消息监听
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)privateLetterArray
{
    if (!_privateLetterArray) {
        _privateLetterArray = [NSMutableArray array];
    }
    return _privateLetterArray;
}

-(NSMutableArray *)userIDArray
{
    if (!_userIDArray) {
        _userIDArray = [NSMutableArray array];
    }
    return _userIDArray;
}

-(NSMutableArray *)conversationArray
{
    if (!_conversationArray) {
        _conversationArray = [NSMutableArray array];
    }
    return _conversationArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - <获取环信会话列表用户个人信息>
-(void)getUserInfoDataWithUser_ids:(NSString *)user_ids hud:(MBProgressHUD *)hud
{
    NSDictionary *dictParameter = @{@"user_ids":user_ids,
                                    @"user_id":kUserDefaultObject(kUserInfo)};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetUserInfo];
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            
            if ([code isEqual:@200]) {
                GetUserInfoDataModel *modelData = [[GetUserInfoDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.privateLetterArray = [NSMutableArray arrayWithArray:modelData.result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
//                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
//                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
//                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
//                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
//            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
//            [hudWarning hideAnimated:YES afterDelay:1.0];
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
    
    UINib *nibPrivate = [UINib nibWithNibName:NSStringFromClass([PrivateLetterCell class]) bundle:nil];
    [self.tableView registerNib:nibPrivate forCellReuseIdentifier:NSStringFromClass([PrivateLetterCell class])];
}

#pragma mark - <获取会话数据>
-(void)getConversationDataWithHUD:(MBProgressHUD *)hud
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    [self.conversationArray removeAllObjects];
    [self.userIDArray removeAllObjects];
    
    NSMutableArray *timeStampArray = [NSMutableArray array];
    for (EMConversation *conversation in conversations) {
        //获取最新的消息
        EMMessage *lastMessage = conversation.latestMessage;
        NSNumber *timeStampNum = [NSNumber numberWithLongLong:lastMessage.timestamp];
        [timeStampArray addObject:timeStampNum];
//        //获取对方的ID存入id数组
//        if (lastMessage.direction == EMMessageDirectionSend) {
//            [self.userIDArray addObject:lastMessage.to];
//        }else if (lastMessage.direction == EMMessageDirectionReceive){
//            [self.userIDArray addObject:lastMessage.from];
//        }
    }
    
    [timeStampArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    NSLog(@"%@",timeStampArray);
    for (NSNumber *item in timeStampArray) {
        long long timeStamp = [item longLongValue];
        for (EMConversation *conversation in conversations) {
            EMMessage *lastMessage = conversation.latestMessage;
            if (timeStamp == conversation.latestMessage.timestamp) {
                //获取对方的ID存入id数组
                if (lastMessage.direction == EMMessageDirectionSend) {
                    [self.userIDArray addObject:lastMessage.to];
                }else if (lastMessage.direction == EMMessageDirectionReceive){
                    [self.userIDArray addObject:lastMessage.from];
                }
                
                //存好会话
                [self.conversationArray addObject:conversation];
            }
        }
    }
    
    //拼接user_id
    NSMutableString *user_ids = [NSMutableString string];
    for (int i=0; i<self.userIDArray.count; i++) {
        NSString *user_id = self.userIDArray[i];
        if (i==0) {
            [user_ids appendString:user_id];
        }else{
            [user_ids appendFormat:@"_%@",user_id];
        }
    }
    
    //请求用户个人信息数据
    if (![user_ids isEqualToString:@""]) {
        [self getUserInfoDataWithUser_ids:user_ids hud:hud];
    }else{
        [hud hideAnimated:YES afterDelay:1.0];
    }
    
}


#pragma mark - <跳转“私信聊天”页面>
-(void)jumpToSingleChatVCWithUserID:(NSString *)user_id
{
    ZHJMessageViewController *singleChatVC = [[ZHJMessageViewController alloc]initWithConversationChatter:user_id conversationType:EMConversationTypeChat];
    singleChatVC.delegate = self;
    singleChatVC.dataSource = self;
    singleChatVC.navigationItem.title = user_id;

    [self.navigationController pushViewController:singleChatVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshConversationList" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self getConversationDataWithHUD:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshUnreadIMCount" object:nil];
    }];
}












#pragma mark - **** EMChatManagerDelegate *****
-(void)messagesDidReceive:(NSArray *)aMessages
{
//    [self getConversationDataWithHUD:nil];
    [self getConversationDataWithHUD:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshUnreadIMCount" object:nil];
//    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
//        [self getConversationDataWithHUD:nil];
//    }];
}

#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.privateLetterArray.count==0) {
        return 1;
    }else{
        return self.privateLetterArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.privateLetterArray.count==0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }else{
        PrivateLetterCell *cellPrivate = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PrivateLetterCell class])];
        GetUserInfoResultModel *modelResult = self.privateLetterArray[indexPath.row];
        //获取单条会话
        EMConversation *conversation = self.conversationArray[indexPath.row];
        //获取最新的消息
        EMMessage *lastMessage = conversation.latestMessage;
        
        //获取对方的昵称
//        cellPrivate.labelNickName.text = modelResult.nickname;
        //获取对方头像
//        NSString *imgStr = modelResult.headimg;
//        NSURL *imgURL = [NSURL URLWithString:imgStr];
//        [cellPrivate.imgViewPortrait sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
        //获取消息时间
//        double timeStamp = (double)lastMessage.timestamp;
//        NSTimeInterval timeInterval = timeStamp;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"MM-dd HH:mm"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
//        NSString *dateStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
//        cellPrivate.labelTime.text = dateStr;
        //获取未读消息数量
//        if (conversation.unreadMessagesCount>0) {
//            cellPrivate.btnUnread.badgeValue = [NSString stringWithFormat:@"%d",conversation.unreadMessagesCount];
//        }
//        cellPrivate.btnUnread.badgeFont = [UIFont systemFontOfSize:10];
//        cellPrivate.btnUnread.badgeOriginX = cellPrivate.btnUnread.frame.size.width-10;
        
        //获取最后一条信息的文本内容
        EMMessageBody *messageBody = lastMessage.body;
        NSString *latestMessageTitle = [NSString string];
        switch(messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            }break;
            case EMMessageBodyTypeText:{
                //表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                           convertToSystemEmoticons:((EMTextMessageBody*)messageBody).text];
                latestMessageTitle = didReceiveText;
                if([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle =@"[动画表情]";
                }
            }break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[音频]";
            }break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle =@"[位置]";
            }break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle =@"[视频]";
            }break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle =@"[文件]";
            }break;
                
            default:
                break;
        }
//        cellPrivate.labelContent.text = latestMessageTitle;
        
        NSDictionary *dictMessage = @{@"nickName":modelResult.nickname,
                                      @"headImg":modelResult.headimg,
                                      @"timeStamp":[NSString stringWithFormat:@"%lld",lastMessage.timestamp],
                                      @"unRead":[NSString stringWithFormat:@"%d",conversation.unreadMessagesCount],
                                      @"content":latestMessageTitle};
        cellPrivate.dictMessage = dictMessage;
        return cellPrivate;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetUserInfoResultModel *modelResult = self.privateLetterArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToSingleChatVCFromPrivateLetterVC" object:modelResult];
}

@end
