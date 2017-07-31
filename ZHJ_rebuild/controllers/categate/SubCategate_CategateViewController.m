//
//  SubCategate_CategateViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/10.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubCategate_CategateViewController.h"

//cells
#import "Categate_CategateTableViewCell.h"
#import "CategoryProductNameCell.h"

//models
#import "AllClassifyModel.h"
#import "AllClassifyResultModel.h"
#import "AllClassifyChidrenFirstModel.h"



@interface SubCategate_CategateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataResultArray;
@property (nonatomic, strong)NSArray *dataChildFirstArray;
@property (nonatomic, strong)NSArray *dataChildSecondArray;
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)UITableView *rightTableView;
@property (nonatomic, strong)AllClassifyModel *model;

@property (nonatomic, strong)MBProgressHUD *hud;

@end

@implementation SubCategate_CategateViewController

#pragma mark - <懒加载>
//-(NSMutableArray *)dataArray
//{
//    if (!_dataArray) {
//        _dataArray = [[NSMutableArray alloc]init];
//    }
//    return _dataArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initLeftTableView];
    [self initRightTableView];
    [self getMainData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    if ([self.leftTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
//        // 默认选择第一个cell
//        [self.leftTableView.delegate tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    }
//}
//任务，测试进度显示
- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        self.hud.progress = progress;
        usleep(50000);
    }
}

#pragma mark - <请求数据>
-(void)getMainData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetAllClassify];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            AllClassifyModel *model = [[AllClassifyModel alloc]initWithDictionary:dataDict error:nil];
            [hud hideAnimated:YES afterDelay:1.0];
            
            if ([model.code isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                self.model = model;
                self.dataResultArray = model.data.result;
                AllClassifyResultModel *resultModel = self.dataResultArray[0];
                self.dataChildFirstArray = resultModel.children;
                
                //回到主线程初始化
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.leftTableView reloadData];
                    [self.rightTableView reloadData];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
    
    
}



#pragma mark - <初始化左侧segmentView>
-(void)initLeftTableView
{
    
    self.leftTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(110);
    }];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.backgroundColor = kColorFromRGB(kLightGray);
    self.leftTableView.rowHeight = 50;
    
    UINib *nibProductNameCell = [UINib nibWithNibName:NSStringFromClass([CategoryProductNameCell class]) bundle:nil];
    [self.leftTableView registerNib:nibProductNameCell forCellReuseIdentifier:NSStringFromClass([CategoryProductNameCell class])];

    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - <初始化右侧tableView>
-(void)initRightTableView
{
    self.rightTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.rightTableView];
    __weak typeof(self) weakSelf = self;
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftTableView.mas_right);
        make.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.backgroundColor = kColorFromRGB(kLightGray);
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedRowHeight = 100.f;
    
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self.rightTableView registerClass:[Categate_CategateTableViewCell class] forCellReuseIdentifier:NSStringFromClass([Categate_CategateTableViewCell class])];
}



#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    
}














#pragma mark - ******** LeftSideSegmentViewDelegate ********
//-(void)leftSideSegmentView:(LeftSideSegmentView *)leftSideSegmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%@",self.dataArray[indexPath.row]);
//}


#pragma mark - ****** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.leftTableView) {
        return 1;
    }else{
        return self.dataChildFirstArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.dataResultArray.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        return 50;
    }else{
        Categate_CategateTableViewCell *cell = [[Categate_CategateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([Categate_CategateTableViewCell class])];
        AllClassifyChidrenFirstModel *modelFirst = self.dataChildFirstArray[indexPath.section];
        
        cell.model = modelFirst;
        return cell.cellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return 0.1f;
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        CategoryProductNameCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CategoryProductNameCell class])];
        cell.backgroundColor = kColorFromRGB(kLightGray);
            AllClassifyResultModel *model = self.dataResultArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.labelName.textColor = kColorFromRGB(kThemeYellow);
        }else{
            cell.labelName.textColor = kColorFromRGB(kBlack);
        }
        
        cell.model = model;
        return cell;
    }else{
        Categate_CategateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Categate_CategateTableViewCell class])];
        AllClassifyChidrenFirstModel *model = self.dataChildFirstArray[indexPath.section];
        cell.model = model;
//        [self.rightTableView reloadData];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return nil;
    }else{
        AllClassifyChidrenFirstModel *model = self.dataChildFirstArray[section];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 100, 30)];
        headerView.backgroundColor = kColorFromRGB( kLightGray);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
        
        titleLabel.text = model.name;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:titleLabel];
        
        return headerView;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = kColorFromRGB(kThemeYellow);
        
        AllClassifyResultModel *modelResult = self.dataResultArray[indexPath.row];
        self.dataChildFirstArray = modelResult.children;
        //刷新右边tableView 的数据
        [self.rightTableView reloadData];
        //右边tableview滚回顶部
        [self.rightTableView setScrollsToTop:YES];
    }
    NSLog(@"%@_%ld",[tableView class],(long)indexPath.row);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = kColorFromRGB(kBlack);
//        if (indexPath.row == 0) {
//            cell.textLabel.textColor = kColorFromRGB(kThemeYellow);
//        }
    }
}


@end
