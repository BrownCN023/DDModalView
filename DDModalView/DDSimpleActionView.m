//
//  DDSimpleActionView.m
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDSimpleActionView.h"
#import "NSString+DDModal.h"
#import "UIButton+DDModalHighlightColor.h"
#define DDModalActionRowHeight 56.0f

@interface DDSimpleActionItemCell : UITableViewCell

@property (nonatomic,strong) UILabel * itemLabel;
@property (nonatomic,strong) UIView * topLineView;
@property (nonatomic,strong) NSIndexPath * indexPath;

- (void)configWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath;

@end

@implementation DDSimpleActionItemCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupData];
        [self setupSubviews];
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupData];
        [self setupSubviews];
        [self setupLayout];
    }
    return self;
}

- (void)setupData{
    
}

- (void)setupSubviews{
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.backgroundColor = UIColor.whiteColor;
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = DDModal_COLOR_Hex(0xF0F0F0);
    
    [self.contentView addSubview:self.itemLabel];
    [self.contentView addSubview:self.topLineView];
    
}

- (void)setupLayout{
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)configWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.itemLabel.text = title;
}

- (UILabel *)itemLabel{
    if(!_itemLabel){
        UILabel * v = [[UILabel alloc] init];
        v.font = [UIFont boldSystemFontOfSize:16];
        v.textAlignment = NSTextAlignmentCenter;
        v.textColor = DDModal_COLOR_Hex(0x494949);
        _itemLabel = v;
    }
    return _itemLabel;
}

- (UIView *)topLineView{
    if(!_topLineView){
        UIView * v = [[UIView alloc] init];
        v.backgroundColor = DDModal_COLOR_Hex(0xEFEFEF);
        _topLineView = v;
    }
    return _topLineView;
}

@end







@interface DDSimpleActionView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIButton * cancelButton;

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * messageLabel;

@property (nonatomic,copy) NSAttributedString * alertTitleAttr;
@property (nonatomic,copy) NSAttributedString * alertMessageAttr;

@property (nonatomic,assign) CGFloat alertTitleHeight;
@property (nonatomic,assign) CGFloat alertMessageHeight;

@property (nonatomic,copy) NSString * cancelTitle;
@property (nonatomic,copy) NSArray * otherItems;

@property (nonatomic,copy) void (^onCancelBlock)(void);
@property (nonatomic,copy) void (^onItemBlock)(NSInteger itemIndex);

@end

@implementation DDSimpleActionView

+ (DDSimpleActionView *)showActionInView:(UIView *)view
                                  title:(NSString *)title
                                message:(NSString *)message
                                 cancel:(NSString *)cancel
                          onCancelBlock:(void (^)(void))onCancelBlock
                             otherItems:(NSArray<NSString *> *)otherItems
                            onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock{
    DDSimpleActionView * modalView = [[DDSimpleActionView alloc] initWithFrame:view.bounds];
    [view addSubview:modalView];
    [modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    if(!message){
        message = title;
        title = nil;
    }
    
    modalView.cancelTitle = cancel;
    modalView.otherItems = otherItems;
    modalView.onCancelBlock = onCancelBlock;
    modalView.onItemBlock = onItemBlock;
    
    CGFloat targetMaxWidth = (DDModalViewWidth(view)-modalView.popMarginLeft-modalView.popMarginRight-30);
    if(title && title.length > 0){
        modalView.alertTitleAttr = [title modalSimpleAttributedString:[UIFont boldSystemFontOfSize:16]
                                                                color:[UIColor whiteColor]
                                                          lineSpacing:1.0
                                                            alignment:NSTextAlignmentCenter];
        CGFloat alertTitleHeight = [modalView.alertTitleAttr
                                    boundingRectWithSize:CGSizeMake(targetMaxWidth, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    context:nil].size.height+0.5;
        modalView.alertTitleHeight = alertTitleHeight;
    }
    
    if(message && message.length > 0){
        modalView.alertMessageAttr = [message modalSimpleAttributedString:[UIFont systemFontOfSize:13]
                                                                    color:[UIColor whiteColor]
                                                              lineSpacing:0.5
                                                                alignment:NSTextAlignmentCenter];
        CGFloat alertMessageHeight = [modalView.alertMessageAttr
                                      boundingRectWithSize:CGSizeMake(targetMaxWidth, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      context:nil].size.height+0.5;
        modalView.alertMessageHeight = modalView.alertTitleHeight>0.0f?alertMessageHeight:(MAX(40, alertMessageHeight+20));
    }
    
    [modalView resetSetup];
    return modalView;
}

#pragma mark - Override
- (DDModalPopAnimation)showPopAnimation{
    return DDModalPopAnimationBottom;
}
- (DDModalPopAnimation)hidePopAnimation{
    return DDModalPopAnimationBottom;
}

- (CGFloat)popMarginLeft{
    return 10.0f;
}
- (CGFloat)popMarginRight{
    return 10.0f;
}
- (CGFloat)popMarginBottom{
    return 0.0f;
}

- (CGFloat)topHeight{
    CGFloat targetTopHeight = self.topPaddingTop + self.titleAndMessageInterval + self.topPaddingBottom + self.alertTitleHeight + self.alertMessageHeight;
    return targetTopHeight;
}

- (CGFloat)topPaddingTop{
    if(self.alertTitleHeight > 0){
        return 20.0f;
    }
    return 0.0f;
}

- (CGFloat)topPaddingBottom{
    if(self.alertTitleHeight > 0){
        return 20.0f;
    }
    return 0.0f;
}

- (CGFloat)titleAndMessageInterval{
    if(self.alertTitleHeight > 0 && self.alertMessageHeight > 0){
        return 7.0;
    }
    return 0.0f;
}

- (CGFloat)bottomHeight{
    return DDModalActionRowHeight+20+DDModal_SAFE_BOTTOM_HEIGHT;
}

- (CGFloat)contentHeight{
    CGFloat totalContentHeight = self.otherItems.count*DDModalActionRowHeight;
    CGFloat maxHeight = DDModalViewHeight(self)-DDModalActionRowHeight;
    BOOL scrollEnabled = NO;
    if(totalContentHeight+self.topHeight+self.bottomHeight > maxHeight){
        totalContentHeight = maxHeight-(self.topHeight+self.bottomHeight);
        scrollEnabled = YES;
    }
    self.tableView.scrollEnabled = scrollEnabled;
    return totalContentHeight;
}

#pragma mark - Setup
- (void)setup{}
- (void)setupData{
    [super setupData];
}

- (void)setupSubviews{
    [super setupSubviews];
    
    self.popView.backgroundColor = [UIColor clearColor];
    self.bottomView.backgroundColor = [UIColor clearColor];
    
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.messageLabel];
    [self.contentView addSubview:self.tableView];
    [self.bottomView addSubview:self.cancelButton];
    
    [self.tableView registerClass:[DDSimpleActionItemCell class] forCellReuseIdentifier:@"DDSimpleActionItemCell"];
    if(self.otherItems.count > 0){
        [self.contentView modalLayerCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-self.popMarginLeft-self.popMarginRight, self.contentHeight) cornerSize:self.cornerSize];
    }else{
        [self.topView modalLayerCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRect:CGRectMake(0, 0, DDModalViewWidth(self)-self.popMarginLeft-self.popMarginRight, self.topHeight) cornerSize:self.cornerSize];
    }
    [self.cancelButton modalLayerCorners:(UIRectCornerAllCorners) cornerRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-self.popMarginLeft-self.popMarginRight, self.bottomHeight-20-DDModal_SAFE_BOTTOM_HEIGHT) cornerSize:self.cornerSize];
}

- (void)setupLayout{
    [super setupLayout];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(self.alertTitleHeight);
        make.top.mas_equalTo(self.topPaddingTop);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(self.alertMessageHeight);
        make.top.mas_equalTo(self.topPaddingTop+self.alertTitleHeight+self.titleAndMessageInterval);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.left.equalTo(self.bottomView).offset(0);
        make.right.equalTo(self.bottomView).offset(0);
        make.bottom.equalTo(self.bottomView).offset(-10-DDModal_SAFE_BOTTOM_HEIGHT);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
}

- (void)clickCancelButton:(id)sender{
    [self dismiss:nil];
}

#pragma mark - UITableViewDelegate/UITableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.otherItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DDModalActionRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSimpleActionItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDSimpleActionItemCell" forIndexPath:indexPath];
    
    [cell configWithTitle:self.otherItems[indexPath.row] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.onItemBlock){
        self.onItemBlock(indexPath.row);
    }
    [self dismiss:^{
        
    }];
}

#pragma mark - Getter
- (UITableView *)tableView{
    if(!_tableView){
        UITableView * v = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        v.delegate = self;
        v.dataSource = self;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.estimatedRowHeight = 0;
        v.estimatedSectionFooterHeight = 0;
        v.estimatedSectionHeaderHeight = 0;
        v.separatorColor = DDModal_COLOR_Hex(0xEFEFEF);
        v.tableFooterView = [UIView new];
        _tableView = v;
    }
    return _tableView;
}

- (UIButton *)cancelButton{
    if(!_cancelButton){
        UIButton * v = [UIButton buttonWithType:UIButtonTypeCustom];
        [v setTitle:(self.cancelTitle?self.cancelTitle:@"取消") forState:UIControlStateNormal];
        v.backgroundColor = DDModal_COLOR_Hex(0xFFFFFF);
        v.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        v.tintColor = DDModal_COLOR_Hex(0x494949);
        [v setTitleColor:DDModal_COLOR_Hex(0x494949) forState:UIControlStateNormal];
        [v addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        v.highlightColor = DDModal_COLOR_Hex(0xF0F0F0);
        _cancelButton = v;
    }
    return _cancelButton;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * v = [[UILabel alloc] init];
        v.numberOfLines = 0;
        v.attributedText = self.alertTitleAttr;
        v.textColor = DDModal_COLOR_Hex(0x494949);
        _titleLabel = v;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if(!_messageLabel){
        UILabel * v = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0.0)];
        v.numberOfLines = 0;
        v.attributedText = self.alertMessageAttr;
        v.textColor = DDModal_COLOR_Hex(0x7c7c7c);
        _messageLabel = v;
    }
    return _messageLabel;
}


@end