//
//  DDAlertView.m
//  DDModalViewDemo
//
//  Created by abiaoyo on 2020/1/13.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "DDAlertView.h"
#import "NSString+DDModal.h"
#import "UIButton+DDModalHighlightColor.h"
#import "DDModalConfig.h"

#define DDAlertViewRowHeight 56.0f

@interface DDAlertItemCell : UICollectionViewCell
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * topLineView;
@property (nonatomic,strong) UIView * rightLineView;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) UIVisualEffectView * effectView;
@end

@implementation DDAlertItemCell
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
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [DDModalConfig sharedConfig].contentBackgroundColor;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView.hidden = YES;
    [self.contentView addSubview:self.effectView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.rightLineView];
}

- (void)initLayout{
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.top.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
    }];
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * v = [[UILabel alloc] init];
        v.font = [DDModalConfig sharedConfig].titleFont;
        v.textAlignment = NSTextAlignmentCenter;
        v.textColor = [DDModalConfig sharedConfig].titleColor;
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

- (UIView *)rightLineView{
    if(!_rightLineView){
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [DDModalConfig sharedConfig].separatorColor;
        _rightLineView.hidden = YES;
    }
    return _rightLineView;
}

- (void)configWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath{
    self.titleLabel.text = title;
    self.indexPath = indexPath;
}

@end




@interface DDAlertView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * messageLabel;

@property (nonatomic,copy) NSAttributedString * alertTitleAttr;
@property (nonatomic,copy) NSAttributedString * alertMessageAttr;

@property (nonatomic,assign) CGFloat alertTitleHeight;
@property (nonatomic,assign) CGFloat alertMessageHeight;

@property (nonatomic,strong) NSArray * otherItems;
@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,copy) NSString * cancelTitle;

@property (nonatomic,copy) void (^onCancelBlock)(void);
@property (nonatomic,copy) void (^onItemBlock)(NSInteger itemIndex);

@end

@implementation DDAlertView

+ (DDAlertView *)showAlertInView:(UIView *)view
                           title:(NSString *)title
                         message:(NSString *)message
                          cancel:(NSString *)cancel
                   onCancelBlock:(void (^)(void))onCancelBlock
                      otherItems:(NSArray<NSString *> *)otherItems
                     onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock{
    
    DDAlertView * alertView = [self alertInView:view
                                          title:title
                                        message:message
                                         cancel:cancel
                                  onCancelBlock:onCancelBlock
                                     otherItems:otherItems
                                    onItemBlock:onItemBlock];
    [alertView show:nil];
    return alertView;
}

+ (DDAlertView *)alertInView:(UIView *)view
                             title:(NSString *)title
                           message:(NSString *)message
                            cancel:(NSString *)cancel
                     onCancelBlock:(void (^)(void))onCancelBlock
                        otherItems:(NSArray<NSString *> *)otherItems
                       onItemBlock:(void (^)(NSInteger itemIndex))onItemBlock{
    
    DDAlertView * modalView = [[DDAlertView alloc] initWithFrame:view.bounds];
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
        modalView.alertTitleAttr = [title modalSimpleAttributedString:[DDModalConfig sharedConfig].titleFont
                                                                color:[DDModalConfig sharedConfig].titleColor
                                                          lineSpacing:0.5
                                                            alignment:NSTextAlignmentCenter];
        CGFloat alertTitleHeight = [modalView.alertTitleAttr
                                    boundingRectWithSize:CGSizeMake(targetMaxWidth, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    context:nil].size.height+0.5;
        modalView.alertTitleHeight = alertTitleHeight;
    }
    
    if(message && message.length > 0){
        modalView.alertMessageAttr = [message modalSimpleAttributedString:[DDModalConfig sharedConfig].messageFont
                                                                    color:[DDModalConfig sharedConfig].messageColor
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
    CGFloat maxHeight = DDModalViewHeight(self)-DDAlertViewRowHeight;
    CGFloat targetMaxHeight = maxHeight - self.topHeight - self.bottomHeight;
    
    CGFloat itemHeight = self.isConfirm?DDAlertViewRowHeight:((self.otherItems.count+1)*DDAlertViewRowHeight);
    if(itemHeight > targetMaxHeight){
        self.collectionView.scrollEnabled = YES;
        itemHeight = targetMaxHeight;
    }
    return itemHeight;
}

- (CGFloat)bottomHeight{
    return 0.0f;
}

- (BOOL)isConfirm{
    return self.otherItems.count == 1;
}

- (void)tapModalView:(UITapGestureRecognizer *)tapGes{
    
}

#pragma mark - Setup
- (void)setupData{
    [super setupData];
}

- (void)setupSubviews{
    [super setupSubviews];
    
    self.popView.backgroundColor = [UIColor clearColor];
    self.topView.backgroundColor = [DDModalConfig sharedConfig].topBackgroundColor;
    
    if(self.isConfirm){
        self.contentView.backgroundColor = UIColor.clearColor;
        self.contentView.effectView.hidden = YES;
    }else{
        self.contentView.backgroundColor = [DDModalConfig sharedConfig].contentBackgroundColor;
    }
    
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.messageLabel];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:DDAlertItemCell.class forCellWithReuseIdentifier:@"DDAlertItemCell"];
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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Setter/Getter
- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * v = [[UILabel alloc] init];
        v.numberOfLines = 0;
        v.attributedText = self.alertTitleAttr;
        v.textColor = [DDModalConfig sharedConfig].titleColor;
        _titleLabel = v;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if(!_messageLabel){
        UILabel * v = [[UILabel alloc] init];
        v.numberOfLines = 0;
        v.attributedText = self.alertMessageAttr;
        v.textColor = [DDModalConfig sharedConfig].messageColor;
        _messageLabel = v;
    }
    return _messageLabel;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.scrollDirection = self.isConfirm?UICollectionViewScrollDirectionHorizontal:UICollectionViewScrollDirectionVertical;
        
        UICollectionView * v = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        v.delegate = self;
        v.dataSource = self;
        v.backgroundColor = UIColor.clearColor;
        _collectionView = v;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.isConfirm){
        if(section == 0){
            return 1;
        }else{
            return 1;
        }
    }else{
        if(section == 0){
            return self.otherItems.count;
        }else{
            return 1;
        }
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDAlertItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDAlertItemCell" forIndexPath:indexPath];
    
    if(self.isConfirm){
        cell.effectView.hidden = NO;
        if(indexPath.section == 0){
            [cell configWithTitle:self.cancelTitle indexPath:indexPath];
            cell.backgroundView.backgroundColor = DDModalConfig.sharedConfig.cancelBackgroundColor;
            cell.titleLabel.font = DDModalConfig.sharedConfig.cancelFont;
            cell.titleLabel.textColor = DDModalConfig.sharedConfig.cancelColor;
            cell.rightLineView.hidden = NO;
        }else{
            [cell configWithTitle:self.otherItems[indexPath.row] indexPath:indexPath];
            cell.backgroundView.backgroundColor = DDModalConfig.sharedConfig.okBackgroundColor;
            cell.titleLabel.font = DDModalConfig.sharedConfig.okFont;
            cell.titleLabel.textColor = DDModalConfig.sharedConfig.okColor;
            cell.rightLineView.hidden = YES;
        }
    }else{
        cell.rightLineView.hidden = YES;
        cell.backgroundView.backgroundColor = UIColor.clearColor;
        cell.effectView.hidden = YES;
        
        if(indexPath.section == 0){
            [cell configWithTitle:self.otherItems[indexPath.row] indexPath:indexPath];
        }else{
            [cell configWithTitle:self.cancelTitle indexPath:indexPath];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isConfirm){
        return CGSizeMake((DDModalSelfWidth-[self popMarginLeft]-[self popMarginRight])/2.0, DDAlertViewRowHeight);
    }
    return CGSizeMake(DDModalSelfWidth-[self popMarginLeft]-[self popMarginRight], DDAlertViewRowHeight);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.isConfirm){
        if(indexPath.section == 0){
            if(self.onCancelBlock){
                self.onCancelBlock();
            }
        }else{
            if(self.onItemBlock){
                self.onItemBlock(0);
            }
        }
    }else{
        if(indexPath.section == 1){
            if(self.onCancelBlock){
                self.onCancelBlock();
            }
        }else{
            if(self.onItemBlock){
                self.onItemBlock(indexPath.row);
            }
        }
    }
    [self dismiss:nil];
}


@end
