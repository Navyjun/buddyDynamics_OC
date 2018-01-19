//
//  BDModel.m
//  BuddyDynamics
//
//  Created by 张海军 on 2018/1/10.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import "BDModel.h"
#import "BDHelper.h"
#import <YYKit.h>

@implementation BDModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"bbsAuthor" : [AuthorItem class]};
}

- (instancetype)init{
    if (self = [super init]) {
        self.picsViewH = 0.0;
        self.contentH = 0.0;
    }
    return self;
}

- (void)setImgList:(NSArray *)imgList{
    _imgList = imgList;
    self.picsViewH = [self picsViewHWithArray:imgList];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentH = [self contentHWithStr:content];
    self.contentAttStr = [self content2AttStr:content];
}

- (NSAttributedString *)content2AttStr:(NSString *)content{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentTitleSize]}];
    
    // 话题
    NSArray *atResults = [[BDHelper regexTopic] matchesInString:content options:kNilOptions range:content.rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) {
            continue;
        }
        
        if ([attrStr attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [attrStr setColor:[UIColor orangeColor] range:at.range];
        }
    }
    
    return attrStr;
}

- (CGFloat)cellHeight{
    if (_cellHeight == 0) {
        _cellHeight = headViewH + self.contentH + self.picsViewH + opationHandleVH;
    }
    return _cellHeight;
}

- (CGFloat)picsViewHWithArray:(NSArray*)array{
    NSInteger count = array.count;
    _imgItemsArray = [NSMutableArray arrayWithCapacity:count];
    if (count <= 0) {
        return 0;
    }
    CGFloat itemMargin = 4.0;
    NSInteger columCount = count >= 3 ? 3 : (count % 3);
    CGFloat totalW = [UIScreen mainScreen].bounds.size.width - 2 * commMargin - (columCount - 1) * itemMargin;
    CGFloat imgWH = totalW / columCount;
    CGFloat rowCount = (count - 1) / columCount + 1;
    
    NSInteger rowN = 0;
    NSInteger lineN = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        ImageItem *item = [[ImageItem alloc] init];
        item.imgURL = array[i];
        rowN = i / columCount;
        lineN = i % columCount;
        item.imgFrame = CGRectMake((imgWH + itemMargin) * lineN, (imgWH + itemMargin) * rowN + 10, imgWH, imgWH);
        [_imgItemsArray addObject:item];
    }
    
    return imgWH * rowCount + (rowCount - 1) * itemMargin + 20;
}

- (CGFloat)contentHWithStr:(NSString *)string{
    if (string.length<=0) {
        return 0;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * commMargin;
    CGSize size = CGSizeMake(width, MAXFLOAT);
    CGFloat H = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentTitleSize]} context:nil].size.height;
    
    return H;
}


@end



@implementation AuthorItem


@end


@implementation ImageItem

@end
