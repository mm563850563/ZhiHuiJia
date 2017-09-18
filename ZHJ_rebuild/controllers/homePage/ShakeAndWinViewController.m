//
//  ShakeAndWinViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ShakeAndWinViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "SuccessPayViewController.h"

//pods
#import <MarqueeLabel.h>

//tools
#import "HWPopTool.h"

//views
#import "ActivityRuleView.h"
#import "CashingPrizeView.h"
#import "PayTypeView.h"

//models
#import "GetUserPrizeModel.h"
#import "GetUserPrizeResultModel.h"
#import "GetUserPrize_PrizeListModel.h"

#import "PlaceOrderModel.h"
#import "PlaceOrderAliPayModel.h"
#import "PlaceOrderWeChatPayModel.h"
#import "PalceOrderOrderInfoModel.h"
#import "PlaceOrderCallbackModel.h"
#import "PlaceOrderBalanceModel.h"

#import "ShakeDataModel.h"
#import "ShakeResultModel.h"

//AliPay
#import <AlipaySDK/AlipaySDK.h>
//WechatPay
#import "WXApi.h"

//controllers
#import "MyAddressViewController.h"

@interface ShakeAndWinViewController ()<PayTypeViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *scrollLabelBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelWinPrizeCount;
@property (nonatomic, strong)MarqueeLabel *scrollLabel;
@property (nonatomic, strong)ActivityRuleView *ruleView;
@property (nonatomic, strong)UIView *popContentView;
@property (nonatomic, strong)GetUserPrizeResultModel *modelPrizeResult;
@property (nonatomic, strong)ShakeResultModel *modelShakeResult;

@property (nonatomic, strong)UIImageView *imgViewPrize;
@property (nonatomic, strong)UIView *burView;
@property (nonatomic, strong)UIView *payTypeBurView;
@property (nonatomic, strong)NSDictionary *payParameter;
@property (nonatomic, strong)NSString *address_id;

//支付宝支付串码
@property (nonatomic, strong)NSString *pay_code;
//微信支付订单号
@property (nonatomic, strong)NSString *order_sn;

@end

@implementation ShakeAndWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self getUserPrizeData];
    [self initPopContentView];
    [self settingScrollLabel];
    [self settingSelfBecomeFirstResponder];
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(UIImageView *)imgViewPrize
{
    if (!_imgViewPrize) {
        _imgViewPrize = [[UIImageView alloc]initWithFrame:self.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewPrizeTapActionWithGesture:)];
        self.imgViewPrize.userInteractionEnabled = YES;
        [self.imgViewPrize addGestureRecognizer:tap];
    }
    return _imgViewPrize;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self settingSelfResignFirstResponder];
}

#pragma mark - <获取中奖数据>
-(void)getUserPrizeData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetUserPrize];
    NSString *userID = kUserDefaultObject(kUserInfo);
    NSDictionary *dictParameter = @{@"user_id":userID,
                                    @"type_id":self.type_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            GetUserPrizeModel *model = [[GetUserPrizeModel alloc]initWithDictionary:dataDict error:&error];
            if ([model.code isEqualToString:@"200"]) {
                self.modelPrizeResult = model.data.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self sendDataToOutletsWithModel:self.modelPrizeResult];
                    self.payParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                          @"prize_id":self.modelPrizeResult.my_prize.prize_id,
                                          @"pay_type":@"1"};
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
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

#pragma mark - <摇一摇>
-(void)getShakeData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kShake];
    NSString *userID = kUserDefaultObject(kUserInfo);
    NSDictionary *dictParameter = @{@"user_id":userID,
                                    @"type_id":self.type_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            
            if ([code isEqual:@200]) {
                ShakeDataModel *modelData = [[ShakeDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelShakeResult = modelData.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self popPrizeWindowWithModel:self.modelShakeResult hud:hud];
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


#pragma mark - <领取礼品>
-(void)getGetPrizeDataWithPrizeID:(NSString *)prize_id
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetPrize];
    NSString *userID = kUserDefaultObject(kUserInfo);
    NSDictionary *dictParameter = @{@"user_id":userID,
                                    @"prize_id":prize_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getUserPrizeData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [self.imgViewPrize removeFromSuperview];
                        [self jumpToMyAddressVC];
                    };
                });
            }else if ([code isEqual:@301]){
                [hud hideAnimated:YES afterDelay:1.0];
                [self popCashingPrizeView];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [self.imgViewPrize removeFromSuperview];
                    };
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

#pragma mark - <获取短信验证数据>
-(void)getSendMsgDataWithPhoneStr:(NSString *)phoneStr
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSendBindMsg];
    NSDictionary *dictParameter = @{@"mobile":phoneStr,
                                    @"user_id":kUserDefaultObject(kUserInfo)};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <绑定手机请求>
-(void)requestBindMobileWithDictParameter:(NSDictionary *)dictParameter
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kBindMobile];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [self.burView removeFromSuperview];
                        [self jumpToMyAddressVC];
                    };
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

#pragma mark - <获取立即下单数据_支付宝支付>
-(void)getPrizeOrderDataWithAliPayWithPayParameter:(NSDictionary *)dictParameter
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPayPrizeFreight];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            PlaceOrderModel *model = [[PlaceOrderModel alloc]initWithDictionary:dataDict error:&error];
            if (!error) {
                if ([model.code isEqualToString:@"200"]) {
                    PlaceOrderAliPayModel *modelAliPay = model.data.result.aliPay;
                    self.pay_code = modelAliPay.pay_code;
                    
                    //支付串码不为空就调支付宝
                    if (![self.pay_code isEqualToString:@""]) {
                        NSString *scheme = @"ZhiHuiJia";
                        [[AlipaySDK defaultService]payOrder:self.pay_code fromScheme:scheme callback:^(NSDictionary *resultDic) {
                            NSString *resultStatus = resultDic[@"resultStatus"];
                            if ([resultStatus isEqualToString:@"9000"]) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hideAnimated:YES afterDelay:1.0];
                                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"支付成功"];
                                    [hudWarning hideAnimated:YES afterDelay:1.0];
                                    
                                });
                                
                                
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hideAnimated:YES afterDelay:1.0];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"支付失败"];
                                    [hudWarning hideAnimated:YES afterDelay:1.0];
                                });
                                
                            }
                        }];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES afterDelay:1.0];
                            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                            [hudWarning hideAnimated:YES afterDelay:1.0];
                        });
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                    });
                    
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
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

#pragma mark - <获取立即下单数据_微信支付>
-(void)getPrizeOrderDataWithWeChatPayWithDictParameter:(NSDictionary *)dictParameter
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPayPrizeFreight];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            PlaceOrderModel *model = [[PlaceOrderModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                [hud hideAnimated:YES afterDelay:1.0];
                PlaceOrderCallbackModel *modelCallback = model.data.result.wxPay.callback;
                PalceOrderOrderInfoModel *modelOrderInfo = model.data.result.wxPay.order_info;
                self.order_sn = modelOrderInfo.order_sn;
                
                PayReq *payreq = [[PayReq alloc]init];
                payreq.partnerId = modelCallback.partnerid;
                payreq.package = modelCallback.package;
                payreq.prepayId = modelCallback.prepayid;
                payreq.sign = modelCallback.sign;
                payreq.timeStamp = (UInt32)[modelCallback.timestamp intValue];
                payreq.nonceStr = modelCallback.noncestr;
                
                if (![WXApi isWXAppInstalled]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请安装微信"];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                    });
                    
                }else if (![WXApi isWXAppSupportApi]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"不支持微信支付"];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                    });
                }else{
                    [WXApi sendReq:payreq];
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
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

#pragma mark - <微信支付回调二次请求>
-(void)verifyWXPayResult
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kVerifyPayResult];
    if (![self.order_sn isEqualToString:@""]) {
        NSDictionary *dictParameter = @{@"order_sn":self.order_sn};
        
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = dataDict[@"code"];
                if ([code isEqual:@200]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    NSError *error = nil;
                    PalceOrderOrderInfoModel *modelWXPay = [[PalceOrderOrderInfoModel alloc]initWithDictionary:dataDict[@"data"][@"result"] error:&error]; ;
                    SuccessPayViewController *successPayVC = [[SuccessPayViewController alloc]initWithNibName:NSStringFromClass([SuccessPayViewController class]) bundle:nil];
                    successPayVC.modelWX = modelWXPay;
                    [self presentViewController:successPayVC animated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"failurePayJumpToMyOrderVC" object:nil];
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        } failBlock:^(NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }];
    }
}

#pragma mark - <设置礼品收货地址>
-(void)setPrizeUserAddressWithAddressID:(NSString *)address_id prizeID:(NSString *)prize_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSetPrizeUserAddress];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"address_id":address_id,
                                    @"prize_id":prize_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [self.burView removeFromSuperview];
                        [self popPayTypeView];
                    };
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
-(void)sendDataToOutletsWithModel:(GetUserPrizeResultModel *)model
{
    //拼接轮播文字
    NSArray *textArray = model.prize_list;
    NSString *textScroll = @"";
    for (int i=0; i<textArray.count; i++) {
        GetUserPrize_PrizeListModel *model = textArray[i];
        NSString *textName = model.name;
        NSString *textPrize = model.gift_name;
        if (i == 0) {
            textScroll = [textScroll stringByAppendingString:textName];
            textScroll = [textScroll stringByAppendingFormat:@" %@ ",@"摇中了"];
            textScroll = [textScroll stringByAppendingString:textPrize];
        }else{
            textScroll = [textScroll stringByAppendingFormat:@"    %@",textName];
            textScroll = [textScroll stringByAppendingFormat:@" %@ ",@"摇中了"];
            textScroll = [textScroll stringByAppendingString:textPrize];
        }
    }
    self.scrollLabel.text = textScroll;
    NSUInteger length = textScroll.length;
    self.scrollLabel.scrollDuration = length * 0.1;
    
    //中奖人数
    self.labelWinPrizeCount.text = [NSString stringWithFormat:@"已有 %@ 人抢到豪礼",model.count];
    
    //"活动规则"
    self.ruleView.tvActivityRule.text = model.activity_rule;
    
    //礼品图片
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.my_prize.image];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewPrize sd_setImageWithURL:imgURL];
}

#pragma mark - <跳转“我的地址”页面>
-(void)jumpToMyAddressVC
{
    MyAddressViewController *myAddressVC = [[MyAddressViewController alloc]initWithNibName:NSStringFromClass([MyAddressViewController class]) bundle:nil];
    myAddressVC.whereReuseFrom = @"shakeAndWinVC";
    [self.navigationController pushViewController:myAddressVC animated:YES];
}

#pragma mark - <中奖后弹出礼品窗口>
-(void)popPrizeWindowWithModel:(ShakeResultModel *)model hud:(MBProgressHUD *)hud
{
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.image];
    if (![imgStr isEqualToString:@""]) {
        [self.view addSubview:self.imgViewPrize];
        
        NSURL *imgURL = [NSURL URLWithString:imgStr];
        
        [self.imgViewPrize sd_setImageWithURL:imgURL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [hud hideAnimated:YES afterDelay:1.0];
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewPrizeTapActionWithGesture:)];
        self.imgViewPrize.userInteractionEnabled = YES;
        [self.imgViewPrize addGestureRecognizer:tap];
    }else{
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"图片为空"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }
}

#pragma mark - <弹出@“选择支付”页面>
-(void)popPayTypeView
{
    self.payTypeBurView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.payTypeBurView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPaytypeBGViewActionWithTap:)];
    [self.payTypeBurView addGestureRecognizer:tap];
    
    [self.payTypeBurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.payTypeBurView.backgroundColor = kColorFromRGBAndAlpha(0x000000, 0.7);
    
    PayTypeView *payTypeView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PayTypeView class]) owner:nil options:nil].lastObject;
    payTypeView.feeDetail = @"本次需要支付运费8.00元";
    payTypeView.delegate = self;
    [self.payTypeBurView addSubview:payTypeView];
    
    [payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - <礼品窗口点击事件>
-(void)imgViewPrizeTapActionWithGesture:(UITapGestureRecognizer *)tap
{
    if (self.modelShakeResult.prize_id) {
        [self getGetPrizeDataWithPrizeID:self.modelShakeResult.prize_id];
    }else{
        [self getGetPrizeDataWithPrizeID:self.modelPrizeResult.my_prize.prize_id];
    }
    
}

#pragma mark - <支付背景点击事件>
-(void)tapPaytypeBGViewActionWithTap:(UITapGestureRecognizer *)tap
{
    [self.payTypeBurView removeFromSuperview];
}

#pragma mark - <弹出绑定手机页面>
-(void)popCashingPrizeView
{
    [self.imgViewPrize removeFromSuperview];
    
    CashingPrizeView *cashView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CashingPrizeView class]) owner:nil options:nil].lastObject;
    
    self.burView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.burView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBindMobileBGViewActionWithTap:)];
    [self.burView addGestureRecognizer:tap];
    
    [self.burView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.burView.backgroundColor = kColorFromRGBAndAlpha(0x000000, 0.7);
    [self.burView addSubview:cashView];
    
    [cashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <绑定手机背景view点击事件>
-(void)tapBindMobileBGViewActionWithTap:(UITapGestureRecognizer *)tap
{
    [self.burView removeFromSuperview];
}

#pragma mark - <“我的礼品”按钮响应>
- (IBAction)btnMyPrizeAction:(UIButton *)sender
{
    [self.view addSubview:self.imgViewPrize];
}

#pragma mark - <实现摇一摇功能,使self成为第一响应>
-(void)settingSelfBecomeFirstResponder
{
    [self becomeFirstResponder];
}

#pragma mark - <实现摇一摇功能,使self释放第一响应>
-(void)settingSelfResignFirstResponder
{
    [self resignFirstResponder];
}

#pragma mark - <初始化“活动规则弹框”>
-(void)initPopContentView
{
    self.popContentView = [[UIView alloc]initWithFrame:CGRectMake(40, 200, kSCREEN_WIDTH-80, kSCREENH_HEIGHT-250)];
    self.popContentView.backgroundColor = kClearColor;
    
    self.ruleView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ActivityRuleView class]) owner:nil options:nil].lastObject;
    self.ruleView.frame = self.popContentView.bounds;
    self.ruleView.layer.cornerRadius = 5;
    self.ruleView.layer.masksToBounds = YES;
    
    [self.popContentView addSubview:self.ruleView];
}

#pragma mark - <设置文字滚动>
-(void)settingScrollLabel
{
    self.scrollLabel = [[MarqueeLabel alloc] initWithFrame:self.scrollLabelBGView.bounds duration:8.0 andFadeLength:10.0f];
    self.scrollLabel.marqueeType = MLContinuous;    self.scrollLabel.animationCurve = UIViewAnimationOptionRepeat;
    self.scrollLabel.textColor = kColorFromRGB( kWhite);
    self.scrollLabel.continuousMarqueeExtraBuffer = 1.0f;
    self.scrollLabel.font = [UIFont systemFontOfSize:14];
    self.scrollLabel.tag = 101;
    [self.scrollLabelBGView addSubview:self.scrollLabel];
}

#pragma mark - <点击“活动规则”按钮>
- (IBAction)btnMyRulesAction:(UIButton *)sender
{
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:self.popContentView animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //关闭“活动规则”页面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"closeRuleViewAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [[HWPopTool sharedInstance]closeWithBlcok:nil];
    }];
    
    //获取验证码
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"getVerifyCodeFromCashingView" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *phoneStr = x.object;
        if ([phoneStr isEqualToString:@""]) {
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入手机号码"];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        }else{
            [self getSendMsgDataWithPhoneStr:phoneStr];
        }
    }];
    
    //领取礼品绑定手机
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"confirmGetPrizeFromCashingView" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dictParameter = x.object;
        [self requestBindMobileWithDictParameter:dictParameter];
    }];
    
    //选择了地址
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"getPrizeSelectAddressFromShakeAndWinVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *address_id = x.object;
        if (self.modelPrizeResult.my_prize.prize_id && address_id) {
            [self setPrizeUserAddressWithAddressID:address_id prizeID:self.modelPrizeResult.my_prize.prize_id];
        }
    }];
}













#pragma mark - <摇一摇相关方法>
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"began");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self getShakeData];
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {//判断是否摇动结束
        NSLog(@"end");
        
//        // 2.设置播放音效
//        SystemSoundID soundID = 1000;
//        AudioServicesPlaySystemSound (soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{
        return;
    }
}





#pragma mark - ******* PayTypeViewDelegate *******
-(void)didSelectPayType:(NSString *)payType
{
    if ([payType isEqualToString:@"1"]) {
        self.payParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"prize_id":self.modelPrizeResult.my_prize.prize_id,
                              @"pay_type":@"1"};
    }else if([payType isEqualToString:@"2"]){
        self.payParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"prize_id":self.modelPrizeResult.my_prize.prize_id,
                              @"pay_type":@"2"};
    }
    
}

-(void)didClickConfirmWithButton:(UIButton *)button
{
    NSString *pay_type = self.payParameter[@"pay_type"];
    if ([pay_type isEqualToString:@"1"]) {
        [self getPrizeOrderDataWithAliPayWithPayParameter:self.payParameter];
    }else if ([pay_type isEqualToString:@"2"]){
        [self getPrizeOrderDataWithWeChatPayWithDictParameter:self.payParameter];
    }
    
}





@end
