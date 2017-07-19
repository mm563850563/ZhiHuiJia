//
//  GetGiftViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "GetGiftViewController.h"

//cells
#import "GiftListCell.h"

@interface GetGiftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//outlets
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIImageView *imgProgress;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelFinishSendGift;


@property (nonatomic, strong)NSArray *headerImgArray;

@end

@implementation GetGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingOutlets];
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


-(void)settingOutlets
{
    self.headerImgArray = @[@"zhuce",@"fenxiangdali",@"gouwuhaoli"];
    UIImage *imageHeader = [UIImage imageNamed:self.headerImgArray[self.category]];
    [self.imgViewHeader setImage:imageHeader];

    
    //画“填写地址”和“送礼完成”圆角
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.labelAddress.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:self.labelAddress.bounds.size];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.lineWidth = 0.5;
    maskLayer1.strokeColor = [UIColor blackColor].CGColor;
    maskLayer1.fillColor = nil;
    maskLayer1.frame = self.labelAddress.bounds;
    maskLayer1.path = maskPath1.CGPath;
    [self.labelAddress.layer addSublayer:maskLayer1];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.labelAddress.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:self.labelFinishSendGift.bounds.size];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.lineWidth = 0.5;
    maskLayer2.strokeColor = [UIColor blackColor].CGColor;
    maskLayer2.fillColor = nil;
    maskLayer2.frame = self.labelAddress.bounds;
    maskLayer2.path = maskPath2.CGPath;
    [self.labelFinishSendGift.layer addSublayer:maskLayer2];
    
    //collection
    self.flowLayout.minimumLineSpacing = 5;
    CGFloat itemWidth = self.collectionView.frame.size.width/4.2;
    CGFloat itemHeight = itemWidth/4.0*5.0;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.delegate =self;
    self.collectionView.dataSource  = self;
    UINib *nibGift = [UINib nibWithNibName:NSStringFromClass([GiftListCell class]) bundle:nil];
    [self.collectionView registerNib:nibGift forCellWithReuseIdentifier:NSStringFromClass([GiftListCell class])];
}

#pragma mark - <摇一摇 拿大礼>
- (IBAction)btnShakeAction:(UIButton *)sender
{
    
}

#pragma mark - <立即分享>
- (IBAction)btnShareAction:(UIButton *)sender
{
    
}

#pragma mark - <返回按钮响应>
- (IBAction)btnBackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}








#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GiftListCell class]) forIndexPath:indexPath];
    return cell;
}




@end
