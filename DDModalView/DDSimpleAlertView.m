//
//  DDSimpleAlertView.m
//  DDScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDSimpleAlertView.h"
#import "NSString+DDModal.h"
#import "UIButton+DDModalHighlightColor.h"

#define DDSimpleAlertRowHeight 56.0f

@interface DDSimpleAlertItemCell : UITableViewCell

@property (nonatomic,strong) UILabel * itemLabel;
@property (nonatomic,strong) UIView * topLineView;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,copy) void (^onClickItemButtonBlock)(NSIndexPath * indexPath);

- (void)configWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath;

@end

@implementation DDSimpleAlertItemCell

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
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)configWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.itemLabel.text = title;
}

- (void)clickItemButton:(UIButton *)sender{
    if(self.onClickItemButtonBlock){
        self.onClickItemButtonBlock(self.indexPath);
    }
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




@interface DDSimpleAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * messageLabel;

@property (nonatomic,copy) NSAttributedString * alertTitleAttr;
@property (nonatomic,copy) NSAttributedString * alertMessageAttr;

@property (nonatomic,assign) CGFloat alertTitleHeight;
@property (nonatomic,assign) CGFloat alertMessageHeight;

@property (nonatomic,strong) NSArray * otherItems;

@property (nonatomic,assign) BOOL isConfirm;

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSString * cancelTitle;
@property (nonatomic,copy) NSString * okTitle;
@property (nonatomic,strong) UIButton * cancelButton;
@property (nonatomic,strong) UIButton * okButton;

@property (nonatomic,strong) UIView * vLineView;
@property (nonatomic,strong) UIView * hLineView;


@property (nonatomic,copy) void (^onCancelBlock)(void);
@property (nonatomic,copy) void (^onItemBlock)(NSInteger itemIndex);

@end


@implementation DDSimpleAlertView

+ (DDSimpleAlertView *)showAlertInView:(UIView *)view
                                 title:(NSString *)title
                               message:(NSString *)message
                                cancel:(NSString *)cancel
                         onCancelBlock:(void (^)(void))onCancelBlock
                            otherItems:(NSArray<NSString *> *)otherItems
                           onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock{
    
    DDSimpleAlertView * modalView = [[DDSimpleAlertView alloc] initWithFrame:view.bounds];
    [view addSubview:modalView];
    
    [modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    if(!message){
        message = title;
        title = nil;
    }
    modalView.otherItems = otherItems;
    modalView.cancelTitle = cancel;
    modalView.onCancelBlock = onCancelBlock;
    modalView.onItemBlock = onItemBlock;
    
    if(otherItems.count == 1){
        modalView.isConfirm = YES;
        modalView.okTitle = (NSString *)otherItems.firstObject;
    }
    
    CGFloat targetMaxWidth = (DDModalViewWidth(view)-modalView.popMarginLeft-modalView.popMarginRight-30);
    if(title && title.length > 0){
        modalView.alertTitleAttr = [title modalSimpleAttributedString:[UIFont boldSystemFontOfSize:16]
                                                                color:[UIColor whiteColor]
                                                          lineSpacing:0.5
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
                                                              lineSpacing:1
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

- (void)setup{
    
}
- (CGFloat)popMarginLeft{
    return 35.0f;
}
- (CGFloat)popMarginRight{
    return 35.0f;
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

- (CGFloat)contentHeight{
    if(_isConfirm){
        return 0.0f;
    }
    CGFloat maxHeight = DDModalViewHeight(self)-DDSimpleAlertRowHeight;
    CGFloat targetMaxHeight = maxHeight - self.topHeight - self.bottomHeight;

    CGFloat itemHeight = (self.otherItems.count+1)*DDSimpleAlertRowHeight;
    if(itemHeight > targetMaxHeight){
        self.tableView.scrollEnabled = YES;
        itemHeight = targetMaxHeight;
    }
    return itemHeight;
}

- (CGFloat)bottomHeight{
    if(_isConfirm){
        return DDSimpleAlertRowHeight;
    }
    return 0.0f;
}

- (void)tapModalView:(UITapGestureRecognizer *)tapGes{
    
}

#pragma mark - Setup
- (void)setupData{
    [super setupData];
}
- (void)setupSubviews{
    [super setupSubviews];
    
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.messageLabel];
    [self.contentView addSubview:self.tableView];

    [self.bottomView addSubview:self.cancelButton];
    [self.bottomView addSubview:self.okButton];
    [self.tableView registerClass:[DDSimpleAlertItemCell class] forCellReuseIdentifier:@"DDSimpleAlertItemCell"];

    UIView * hLineView = [[UIView alloc] init];
    hLineView.backgroundColor = DDModal_COLOR_Hex(0xEFEFEF);
    [self.bottomView addSubview:hLineView];
    self.hLineView = hLineView;

    UIView * vLineView = [[UIView alloc] init];
    vLineView.backgroundColor = DDModal_COLOR_Hex(0xEFEFEF);
    [self.bottomView addSubview:vLineView];
    self.vLineView = vLineView;

    [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];

    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
        make.centerX.equalTo(self.bottomView);
    }];
}
- (void)setupLayout{
    [super setupLayout];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(self.alertTitleHeight);
        make.top.mas_equalTo(self.topPaddingTop);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(self.alertMessageHeight);
        make.top.mas_equalTo(self.topPaddingTop+self.alertTitleHeight+self.titleAndMessageInterval);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.equalTo(self.okButton);
        make.right.equalTo(self.okButton.mas_left);
    }];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.equalTo(self.cancelButton);
    }];
}

- (void)clickCancelButton:(UIButton *)sender{
    if(self.onCancelBlock){
        self.onCancelBlock();
    }
    [self dismiss:^{

    }];
}

- (void)clickOkButton:(UIButton *)sender{
    [self handleClickItemByItemIndex:0];
}

- (void)handleClickItemByItemIndex:(NSInteger)itemIndex{
    if(self.onItemBlock){
        self.onItemBlock(itemIndex);
    }
    [self dismiss:^{

    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isConfirm){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isConfirm){
        return 0;
    }
    if(section == 0){
        return self.otherItems.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DDSimpleAlertRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = nil;
    if(indexPath.section == 1){
        title = self.cancelTitle;
    }else{
        title = self.otherItems[indexPath.row];
    }
    
    DDSimpleAlertItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDSimpleAlertItemCell" forIndexPath:indexPath];
    [cell configWithTitle:title indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [self handleClickItemByItemIndex:indexPath.row];
    }else{
        [self clickCancelButton:nil];
    }
}

#pragma mark - Setter/Getter
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
        UILabel * v = [[UILabel alloc] init];
        v.numberOfLines = 0;
        v.attributedText = self.alertMessageAttr;
        v.textColor = DDModal_COLOR_Hex(0x7c7c7c);
        _messageLabel = v;
    }
    return _messageLabel;
}

- (UIButton *)cancelButton{
    if(!_cancelButton){
        UIButton * v = [UIButton buttonWithType:UIButtonTypeCustom];
        v.frame = CGRectMake(0, 0, 100, 40);
        [v setTitle:self.cancelTitle forState:UIControlStateNormal];
        v.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        v.tintColor = DDModal_COLOR_Hex(0x494949);
        [v setTitleColor:DDModal_COLOR_Hex(0x494949) forState:UIControlStateNormal];
        [v addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        v.hidden = !_isConfirm;
        v.highlightColor = DDModal_COLOR_Hex(0xF0F0F0);
        _cancelButton = v;
    }
    return _cancelButton;
}

- (UIButton *)okButton{
    if(!_okButton){
        UIButton * v = [UIButton buttonWithType:UIButtonTypeCustom];
        v.frame = CGRectMake(0, 0, 100, 40);
        [v setTitle:self.okTitle forState:UIControlStateNormal];
        v.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        v.tintColor = DDModal_COLOR_Hex(0x494949);
        [v setTitleColor:DDModal_COLOR_Hex(0x494949) forState:UIControlStateNormal];
        [v addTarget:self action:@selector(clickOkButton:) forControlEvents:UIControlEventTouchUpInside];
        v.hidden = !_isConfirm;
        v.highlightColor = DDModal_COLOR_Hex(0xF0F0F0);
        _okButton = v;
    }
    return _okButton;
}

- (UITableView *)tableView{
    if(!_tableView){
        UITableView * v = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        v.delegate = self;
        v.dataSource = self;
        v.estimatedRowHeight = 0;
        v.estimatedSectionFooterHeight = 0;
        v.estimatedSectionHeaderHeight = 0;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.scrollEnabled = NO;
        v.backgroundColor = DDModal_COLOR_Hex(0xEFEFEF);
        v.tableFooterView = [UIView new];
        _tableView = v;
    }
    return _tableView;
}

@end
