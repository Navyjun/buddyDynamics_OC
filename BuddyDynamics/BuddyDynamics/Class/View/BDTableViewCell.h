//
//  BDTableViewCell.h
//  BuddyDynamics
//
//  Created by 张海军 on 2018/1/10.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <YYKit.h>
#import "BDModel.h"

@interface BDTableViewCell : UITableViewCell
@property (nonatomic, strong) BDModel *dataModel;
@end
