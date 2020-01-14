//
//  DDActionView.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/13.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDActionView.h"
#import "NSString+DDModal.h"
#import "UIButton+DDModalHighlightColor.h"
#import "DDModalConfig.h"
#define DDActionViewRowHeight 56.0f


@interface DDActionItemCell : UICollectionViewCell
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * topLineView;
@end

@implementation DDActionItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

- (void)initSubviews{
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [DDModalConfig sharedConfig].selectedBackgroundColor;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.topLineView];
}

- (void)initLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * v = [[UILabel alloc] init];
        v.font = [UIFont boldSystemFontOfSize:16];
        v.textAlignment = NSTextAlignmentCenter;
        v.textColor = DDModal_COLOR_Hex(0x494949);
        _titleLabel = v;
    }
    return _titleLabel;
}

- (UIView *)topLineView{
    if(!_topLineView){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [DDModalConfig sharedConfig].separatorColor;
    }
    return _topLineView;
}

@end











@interface DDActionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;
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

@implementation DDActionView

+ (DDActionView *)showActionInView:(UIView *)view
                             title:(NSString *)title
                           message:(NSString *)message
                            cancel:(NSString *)cancel
                     onCancelBlock:(void (^)(void))onCancelBlock
                        otherItems:(NSArray<NSString *> *)otherItems
                       onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    DDActionView * actionView = [self actionInView:view
                                             title:title
                                           message:message
                                            cancel:cancel
                                     onCancelBlock:onCancelBlock
                                        otherItems:otherItems
                                       onItemBlock:onItemBlock];
    [actionView show:nil];
    return actionView;
}

+ (DDActionView *)actionInView:(UIView *)view
                         title:(NSString *)title
                       message:(NSString *)message
                        cancel:(NSString *)cancel
                 onCancelBlock:(void (^)(void))onCancelBlock
                    otherItems:(NSArray<NSString *> *)otherItems
                   onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    
    DDActionView * modalView = [[DDActionView alloc] initWithFrame:view.bounds];
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
    return DDActionViewRowHeight+20+DDModal_SAFE_BOTTOM_HEIGHT;
}

- (CGFloat)contentHeight{
    CGFloat totalContentHeight = self.otherItems.count*DDActionViewRowHeight;
    CGFloat maxHeight = DDModalViewHeight(self)-DDActionViewRowHeight;
    BOOL scrollEnabled = NO;
    if(totalContentHeight+self.topHeight+self.bottomHeight > maxHeight){
        totalContentHeight = maxHeight-(self.topHeight+self.bottomHeight);
        scrollEnabled = YES;
    }
    self.collectionView.scrollEnabled = scrollEnabled;
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
    self.topView.backgroundColor = [DDModalConfig sharedConfig].topBackgroundColor;
    self.contentView.backgroundColor = [DDModalConfig sharedConfig].contentBackgroundColor;
    
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.messageLabel];
    [self.contentView addSubview:self.collectionView];
    [self.bottomView addSubview:self.cancelButton];
    
    UIView * bottomViewBgView = [UIView new];
    bottomViewBgView.backgroundColor = [DDModalConfig sharedConfig].contentBackgroundColor;
    [self.bottomView insertSubview:bottomViewBgView atIndex:0];
    
    [bottomViewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.left.equalTo(self.bottomView).offset(0);
        make.right.equalTo(self.bottomView).offset(0);
        make.bottom.equalTo(self.bottomView).offset(-10-DDModal_SAFE_BOTTOM_HEIGHT);
    }];
    
    
    [self.collectionView registerClass:DDActionItemCell.class forCellWithReuseIdentifier:@"DDActionItemCell"];
    if(self.otherItems.count > 0){
        [self.contentView modalLayerCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                 cornerRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-self.popMarginLeft-self.popMarginRight, self.contentHeight)
                                 cornerSize:self.cornerSize];
    }else{
        [self.topView modalLayerCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                             cornerRect:CGRectMake(0, 0, DDModalViewWidth(self)-self.popMarginLeft-self.popMarginRight, self.topHeight)
                             cornerSize:self.cornerSize];
    }
    
    [self.cancelButton modalLayerCorners:(UIRectCornerAllCorners)
                              cornerRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-self.popMarginLeft-self.popMarginRight, self.bottomHeight-20-DDModal_SAFE_BOTTOM_HEIGHT) cornerSize:self.cornerSize];
    
    [self.bottomView.effectView modalLayerCorners:(UIRectCornerAllCorners)
                                       cornerRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-self.popMarginLeft-self.popMarginRight, self.bottomHeight-20-DDModal_SAFE_BOTTOM_HEIGHT)
                                       cornerSize:self.cornerSize];
    [bottomViewBgView modalLayerCorners:(UIRectCornerAllCorners)
                             cornerRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-self.popMarginLeft-self.popMarginRight, self.bottomHeight-20-DDModal_SAFE_BOTTOM_HEIGHT)
                             cornerSize:self.cornerSize];
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
    [self.bottomView.effectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.left.equalTo(self.bottomView).offset(0);
        make.right.equalTo(self.bottomView).offset(0);
        make.bottom.equalTo(self.bottomView).offset(-10-DDModal_SAFE_BOTTOM_HEIGHT);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
}

- (void)clickCancelButton:(id)sender{
    [self dismiss:nil];
}


#pragma mark - Getter
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

- (UIButton *)cancelButton{
    if(!_cancelButton){
        UIButton * v = [UIButton buttonWithType:UIButtonTypeCustom];
        [v setTitle:(self.cancelTitle?self.cancelTitle:@"取消") forState:UIControlStateNormal];
        v.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        v.tintColor = DDModal_COLOR_Hex(0x494949);
        [v setTitleColor:DDModal_COLOR_Hex(0x494949) forState:UIControlStateNormal];
        [v addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        v.highlightColor = DDModalConfig.sharedConfig.selectedBackgroundColor;
        v.backgroundColor = UIColor.clearColor;
        _cancelButton = v;
    }
    return _cancelButton;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        UICollectionView * v = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        v.delegate = self;
        v.dataSource = self;
        v.backgroundColor = UIColor.clearColor;
        _collectionView = v;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.otherItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDActionItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDActionItemCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.otherItems[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(DDModalSelfWidth-[self popMarginLeft]-[self popMarginRight], DDActionViewRowHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.onItemBlock){
        self.onItemBlock(indexPath.row);
    }
    [self dismiss:nil];
}

@end
