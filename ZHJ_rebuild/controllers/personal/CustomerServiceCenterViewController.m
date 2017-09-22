//
//  CustomerServiceCenter.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CustomerServiceCenterViewController.h"

//IM
#import "EaseUI.h"
#import "ZHJMessageViewController.h"

@interface CustomerServiceCenterViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imgBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelHotLine;

@property (nonatomic, strong)NSString *phoneStr;

@end

@implementation CustomerServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getCustomerServiceData];
    [self settingNavigation];
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


#pragma mark - <配置navigation>
-(void)settingNavigation
{
    self.navigationItem.title = @"客服中心";
}


#pragma mark - <获取客服中心数据>
-(void)getCustomerServiceData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCustomerService];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSDictionary *result = dataDict[@"data"][@"result"];
                [self fillDataWithResult:result];
                dispatch_async(dispatch_get_main_queue(), ^{
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

#pragma mark - <填充数据>
-(void)fillDataWithResult:(NSDictionary *)result
{
    //背景图
//    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,result[@"image"]];
//    NSURL *url = [NSURL URLWithString:imgStr];
//    [self.imgBGView sd_setImageWithURL:url];
    
    //客服热线文本
    NSString *hotLineStr = [NSString stringWithFormat:@"客服热线：%@",result[@"hotline"]];
    self.labelHotLine.text = hotLineStr;
    
    //分离出客服号码
    NSArray *array = [result[@"hotline"] componentsSeparatedByString:@" "];
    self.phoneStr = array[0];
}

#pragma mark - <跳转“聊天界面”>
-(void)jumpToSingleChatVCWithChatter:(NSString *)chatter
{
    ZHJMessageViewController *singleChatVC = [[ZHJMessageViewController alloc]initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
    singleChatVC.delegate = self;
    singleChatVC.dataSource = self;
    singleChatVC.navigationItem.title = @"智惠加客服";
    [self.navigationController pushViewController:singleChatVC animated:YES];
}

#pragma mark - <拨打热线>
- (IBAction)btnHotLineAction:(UIButton *)sender
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"tel:%@",self.phoneStr];
    NSURL *url = [NSURL URLWithString:str];
    
    [[UIApplication sharedApplication]openURL:url];
}

#pragma mark - <客服聊天>
- (IBAction)btnChatAction:(UIButton *)sender
{
    [self jumpToSingleChatVCWithChatter:@"160"];//客服id为160；
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
        model.avatarImage = [UIImage imageNamed:@"appLogo"];
        model.nickname = @"";
    }
    model.failImageName = @"huantu";
    return model;
}



@end
