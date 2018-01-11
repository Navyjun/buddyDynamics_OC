//
//  ViewController.m
//  BuddyDynamics
//
//  Created by 张海军 on 2018/1/10.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import "ViewController.h"
#import "BDTableViewCell.h"
#import <YYKit.h>
#import "YYFPSLabel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray; /// dataArray
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 初始化
- (void)setupUI{
    self.navigationItem.title = @"buddy dynamics";
    [self tableView];
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - 12;
    _fpsLabel.left = 12;
    [self.view addSubview:_fpsLabel];
}

- (void)addData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 1; i < 16; i++) {
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"format-%zd",i] ofType:@".json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *dataArray = dic[@"data"];
            for (NSDictionary *itemDic in dataArray) {
                BDModel *item = [BDModel modelWithDictionary:itemDic];
                [item cellHeight];
                [self.dataArray addObject:item];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BDTableViewCell class])];
    cell.dataModel = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BDModel *item = self.dataArray[indexPath.row];
    return item.cellHeight;
}



#pragma mark - lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        NSString *classStr = NSStringFromClass([BDTableViewCell class]);
        [_tableView registerNib:[UINib nibWithNibName:classStr bundle:nil] forCellReuseIdentifier:classStr];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
