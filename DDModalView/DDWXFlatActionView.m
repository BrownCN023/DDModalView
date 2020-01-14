//
//  DDWXFlatActionView.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/14.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDWXFlatActionView.h"
#import "NSString+DDModal.h"
#import "UIButton+DDModalHighlightColor.h"
#import "DDModalConfig.h"
#define DDWXFlatActionRowHeight 56.0f
#define DDWXFlatActionFooterHeight 5.0f

@interface DDWXFlatActionItemCell : UICollectionViewCell

@property (nonatomic,strong) UILabel * itemLabel;
@property (nonatomic,strong) UIView * topLineView;
@property (nonatomic,strong) NSIndexPath * indexPath;

- (void)configWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath;

@end

@implementation DDWXFlatActionItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupSubviews];
        [self setupLayout];
    }
    return self;
}

- (void)setupData{
    
}

- (void)setupSubviews{
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [DDModalConfig sharedConfig].selectedBackgroundColor;
    
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
        v.backgroundColor = [DDModalConfig sharedConfig].separatorColor;
        _topLineView = v;
    }
    return _topLineView;
}

@end


@interface DDWXFlatActionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * messageLabel;
@property (nonatomic,copy) NSAttributedString * alertTitleAttr;
@property (nonatomic,copy) NSAttributedString * alertMessageAttr;
@property (nonatomic,assign) CGFloat alertTitleHeight;
@property (nonatomic,assign) CGFloat alertMessageHeight;
@property (nonatomic,copy) NSString * cancelTitle;
@property (nonatomic,copy) NSArray * otherItems;
@property (nonatomic,copy) void (^onItemBlock)(NSInteger itemIndex);
@property (nonatomic,assign) BOOL hasCorner;
@property (nonatomic,strong) UIView * bottomBackgroundView;
@end

@implementation DDWXFlatActionView


+ (DDWXFlatActionView *)showActionInView:(UIView *)view
                                   title:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                           onCancelBlock:(void (^)(void))onCancelBlock
                              otherItems:(NSArray<NSString *> *)otherItems
                             onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    DDWXFlatActionView * actionView = [self createFlatActionInView:view hasCorner:YES title:title message:message cancel:cancel onCancelBlock:onCancelBlock otherItems:otherItems onItemBlock:onItemBlock];
    [actionView show:nil];
    return actionView;
}

+ (DDWXFlatActionView *)actionInView:(UIView *)view
                                   title:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                           onCancelBlock:(void (^)(void))onCancelBlock
                              otherItems:(NSArray<NSString *> *)otherItems
                             onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    return [self createFlatActionInView:view hasCorner:YES title:title message:message cancel:cancel onCancelBlock:onCancelBlock otherItems:otherItems onItemBlock:onItemBlock];
}

+ (DDWXFlatActionView *)showFlatActionInView:(UIView *)view
                                       title:(NSString *)title
                                     message:(NSString *)message
                                      cancel:(NSString *)cancel
                               onCancelBlock:(void (^)(void))onCancelBlock
                                  otherItems:(NSArray<NSString *> *)otherItems
                                 onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    DDWXFlatActionView * actionView = [self flatActionInView:view title:title message:message cancel:cancel onCancelBlock:onCancelBlock otherItems:otherItems onItemBlock:onItemBlock];
    [actionView show:nil];
    return actionView;
}

+ (DDWXFlatActionView *)flatActionInView:(UIView *)view
                                   title:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                           onCancelBlock:(void (^)(void))onCancelBlock
                              otherItems:(NSArray<NSString *> *)otherItems
                             onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    return [self createFlatActionInView:view hasCorner:NO title:title message:message cancel:cancel onCancelBlock:onCancelBlock otherItems:otherItems onItemBlock:onItemBlock];
}

+ (DDWXFlatActionView *)createFlatActionInView:(UIView *)view
                                     hasCorner:(BOOL)hasCorner
                                         title:(NSString *)title
                                       message:(NSString *)message
                                        cancel:(NSString *)cancel
                                 onCancelBlock:(void (^)(void))onCancelBlock
                                    otherItems:(NSArray<NSString *> *)otherItems
                                   onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock
{
    
    DDWXFlatActionView * modalView = [[DDWXFlatActionView alloc] initWithFrame:view.bounds];
    [view addSubview:modalView];
    
    [modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    modalView.hasCorner = hasCorner;
    
    if(!message){
        message = title;
        title = nil;
    }
    modalView.cancelTitle = cancel;
    modalView.otherItems = otherItems;
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
- (UIRectCorner)corners{
    return UIRectCornerTopLeft|UIRectCornerTopRight;
}
- (CGSize)cornerSize{
    if(_hasCorner){
        return [super cornerSize];
    }
    return CGSizeZero;
}
- (CGFloat)popMarginLeft{
    return 0.0f;
}
- (CGFloat)popMarginRight{
    return 0.0f;
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
    return DDModal_SAFE_BOTTOM_HEIGHT;
}
- (CGFloat)contentHeight{
    CGFloat totalContentHeight = (self.otherItems.count+1)*DDWXFlatActionRowHeight+DDWXFlatActionFooterHeight;
    CGFloat maxHeight = DDModalViewHeight(self)-DDWXFlatActionRowHeight;
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
    self.bottomView.backgroundColor = [DDModalConfig sharedConfig].contentBackgroundColor;
    
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.messageLabel];
    [self.contentView addSubview:self.collectionView];
    [self.bottomView modalSimpleBorder:DDModalBorderTypeTop width:0.5 color:[DDModalConfig sharedConfig].separatorColor];
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
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    
}

- (void)clickCancelButton:(id)sender{
    [self dismiss:nil];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return self.otherItems.count;
    }else{
        return 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDWXFlatActionItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDWXFlatActionItemCell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        [cell configWithTitle:self.otherItems[indexPath.row] indexPath:indexPath];
    }else{
        [cell configWithTitle:self.cancelTitle indexPath:indexPath];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(DDModalSelfWidth-[self popMarginLeft]-[self popMarginRight], DDWXFlatActionRowHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(section == 0){
        return CGSizeMake(DDModalSelfWidth, DDWXFlatActionFooterHeight);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        footer.backgroundColor = DDModalConfig.sharedConfig.sectionFooterBackgroundColor;
        return footer;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.onItemBlock){
        self.onItemBlock(indexPath.row);
    }
    [self dismiss:nil];
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
        [v registerClass:DDWXFlatActionItemCell.class forCellWithReuseIdentifier:@"DDWXFlatActionItemCell"];
        [v registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        _collectionView = v;
    }
    return _collectionView;
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
