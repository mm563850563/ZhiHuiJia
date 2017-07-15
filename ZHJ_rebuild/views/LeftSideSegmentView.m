//
//  LeftSideSegmentView.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "LeftSideSegmentView.h"


#define kReuseID @"leftTableViewCell"

@interface LeftSideSegmentView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray *dataArray;

@end

NSInteger leftCellWidth = 100;

@implementation LeftSideSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
    }
    return _dataArray;
}

-(UITableView *)LeftTableView
{
    if (!_LeftTableView) {
        _LeftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, leftCellWidth, self.frame.size.height)];
        _LeftTableView.showsVerticalScrollIndicator = NO;
        _LeftTableView.bounces = NO;
        [self addSubview:_LeftTableView];
        [_LeftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(leftCellWidth);
        }];
    }
    return _LeftTableView;
}

-(UIView *)rightContentView
{
    if (!_rightContentView) {
        _rightContentView = [[UIView alloc]initWithFrame:CGRectMake(leftCellWidth, 0, self.frame.size.width-leftCellWidth, self.frame.size.height)];
        _rightContentView.backgroundColor = kColorFromRGB(kLightGray);
        [self addSubview:_rightContentView];
        __weak typeof(self) weakSelf = self;
        [_rightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.LeftTableView.mas_right).with.offset(0);
            make.top.equalTo(weakSelf.LeftTableView.mas_top);
            make.right.bottom.mas_equalTo(0);
        }];
    }
    return _rightContentView;
}


-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.LeftTableView.delegate = self;
        self.LeftTableView.dataSource = self;
        [self.LeftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseID];
        
        self.dataArray = dataArray;
    }
    return self;
}




#pragma mark - ******* UITableViewDataSource,UITableViewDelegate ********
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseID];
    cell.backgroundColor = kColorFromRGB(kLightGray);
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];
    
    if ([self.delegate respondsToSelector:@selector(leftSideSegmentView:didSelectRowAtIndexPath:)]) {
        [self.delegate leftSideSegmentView:self didSelectRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
}

@end
