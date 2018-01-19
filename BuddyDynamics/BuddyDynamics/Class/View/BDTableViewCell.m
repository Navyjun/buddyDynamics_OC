//
//  BDTableViewCell.m
//  BuddyDynamics
//
//  Created by 张海军 on 2018/1/10.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import "BDTableViewCell.h"
#import "BDHelper.h"
#import <YYLabel.h>

@interface BDTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorIcon;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLable;
@property (weak, nonatomic) IBOutlet UILabel *authorSignLable;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *opationHandleView;

@property (nonatomic, strong) UIView *contentImageView;
@property (strong, nonatomic) YYLabel *contentLabel;
@property (nonatomic, strong) NSMutableArray *picsViewArray;



@end

@implementation BDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    UIView *bottomLien = [[UIView alloc] initWithFrame:CGRectMake(0, opationHandleVH - 0.8, width, 0.5)];
    bottomLien.backgroundColor = [UIColor lightGrayColor];
    [self.opationHandleView addSubview:topLine];
    [self.opationHandleView addSubview:bottomLien];
    
    [self contentLabel];
    [self contentImageView];
}


- (void)setDataModel:(BDModel *)dataModel{
    _dataModel = dataModel;

    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(commMargin);
        make.right.mas_equalTo(self.contentView).offset(-commMargin);
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(dataModel.contentH);
    }];
    
    
    [self layoutPics];
    
    /// 圆角头像
    [self.authorIcon setImageWithURL:[NSURL URLWithString:dataModel.bbsAuthor.headImg] //profileImageURL
                                 placeholder:nil
                                     options:kNilOptions
                                     manager:[BDHelper avatarImageManager] ///< 圆角头像manager，内置圆角处理
                                    progress:nil
                                   transform:nil
                                  completion:nil];
    
    self.contentLabel.attributedText = dataModel.contentAttStr;
    self.authorNameLable.text = dataModel.bbsAuthor.userName;
    self.authorSignLable.text = dataModel.bbsAuthor.signature;
    self.sendTimeLabel.text = dataModel.createDate;
}

- (void)layoutPics{
    NSInteger picCount = _dataModel.imgItemsArray.count;
    for (NSInteger i = 0; i < 9; i++) {
        UIView *view = self.picsViewArray[i];
        if (i >= picCount) {
            [view.layer cancelCurrentImageRequest];
            view.hidden = YES;
        }else{
            ImageItem *item = _dataModel.imgItemsArray[i];
            view.hidden = NO;
            view.frame = item.imgFrame;
            [view.layer removeAnimationForKey:@"contents"];
            @weakify(view);
            [view.layer setImageWithURL:[NSURL URLWithString:item.imgURL]
                            placeholder:nil
                                options:YYWebImageOptionAvoidSetImage
                             completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                 @strongify(view);
                                 view.layer.contents = (id)image.CGImage;
                                 if (from != YYWebImageFromMemoryCacheFast) {
                                     CATransition *transition = [CATransition animation];
                                     transition.duration = 0.15;
                                     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                     transition.type = kCATransitionFade;
                                     [view.layer addAnimation:transition forKey:@"contents"];
                                 }
                                 
                             }];
            
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
}

#pragma mark - lazy
- (UIView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIView alloc] init];
        [self.contentView addSubview:_contentImageView];
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(commMargin);
            make.right.mas_equalTo(self.contentView).offset(-commMargin);
            make.top.mas_equalTo(self.contentLabel.mas_bottom);
            make.bottom.mas_equalTo(self.opationHandleView.mas_top);
        }];
        self.picsViewArray = [NSMutableArray arrayWithCapacity:9];
        for (NSInteger i = 0; i < 9; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor lightTextColor];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            [_contentImageView addSubview:view];
            [self.picsViewArray addObject:view];
        }
    }
    return _contentImageView;
}

- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
