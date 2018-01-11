//
//  BDModel.h
//  BuddyDynamics
//
//  Created by 张海军 on 2018/1/10.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const headViewH = 70.0;
static CGFloat const opationHandleVH = 44.0;
static CGFloat const commMargin = 15.0;
static CGFloat const contentTitleSize = 14.0;


@class AuthorItem;

@interface BDModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;  // 内容
@property (nonatomic, copy) NSString *createDate; // 创建时间
@property (nonatomic, copy) NSString *hotTalk;


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) NSInteger appointCount; // 点赞
@property (nonatomic, assign) NSInteger commentCount; // 评论
@property (nonatomic, assign) NSInteger readCount;  // 观看人数

@property (nonatomic, assign) BOOL recommend;

@property (nonatomic, strong) NSArray *imgList;  // 小图片数组
@property (nonatomic, strong) NSArray *bigImgList; // 大图数组
@property (nonatomic, strong) NSMutableArray *imgItemsArray;

@property (nonatomic, strong) AuthorItem *bbsAuthor; // 用户信息

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat picsViewH;
@property (nonatomic, assign) CGFloat contentH;
@end


@interface AuthorItem : NSObject
@property (nonatomic, copy) NSString *customerId; 
@property (nonatomic, copy) NSString *userName;  // 昵称
@property (nonatomic, copy) NSString *headImg;   // 头像
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *signature; // 个性签名
@end

@interface ImageItem : NSObject
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, assign) CGRect imgFrame;
@end

