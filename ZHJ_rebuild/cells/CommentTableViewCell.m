//
//  CommentTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CommentTableViewCell.h"

#import <TTTAttributedLabel.h>

#import "ReplyCommentCell.h"

@interface CommentTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

//回复tableView
@property (nonatomic, strong)UITableView *replyTableView;
//评论富文本
@property (nonatomic, strong)TTTAttributedLabel *labelComment;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UITableView *)replyTableView
{
    if (!_replyTableView) {
        _replyTableView = [UITableView new];
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ReplyCommentCell class]) bundle:nil];
        [_replyTableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([ReplyCommentCell class])];
        
        _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _replyTableView.scrollEnabled = NO;
        _replyTableView.delegate = self;
        _replyTableView.dataSource = self;
    }
    return _replyTableView;
}




-(void)setReplyArray:(NSMutableArray *)replyArray
{
    _replyArray = replyArray;
    [self.replyTableView reloadData];
    //强制刷新回复界面，然后更新回复区域高度
    [self.replyTableView layoutIfNeeded];
    
    [self.replyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.replyTableView.contentSize.height);
    }];
    
    //获取当前的回复区域界面的高度
    self.cellHeight = self.replyTableView.frame.origin.y + self.replyTableView.contentSize.height + 60;
}

-(void)setUI
{
    __weak typeof(self) weakSelf = self;
    [self.contentView addSubview:self.replyTableView];
    [self.replyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imgPortrait.mas_bottom).with.offset(5);
        make.left.mas_equalTo(weakSelf.labelNickName.mas_left);
        make.trailing.mas_equalTo(-10);
    }];
}

-(void)drawRect:(CGRect)rect
{
    [self setUI];
}





#pragma mark - *** UITableViewDelegate,UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReplyCommentCell class])];
    cell.labelReply.text = self.replyArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *replyStr = self.replyArray[indexPath.row];
    
    ReplyCommentCell *cell = [[ReplyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ReplyCommentCell class])];
    
    CGFloat height = [GetHeightOfText getHeightWithContent:replyStr font:12 contentSize:CGSizeMake(cell.contentView.frame.size.width, CGFLOAT_MAX)];
    return height+5;
}






@end
