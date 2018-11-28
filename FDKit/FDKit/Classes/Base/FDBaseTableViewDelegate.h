//
//  BPWBaseTableViewDelegate.h
//  FDKit
//
//  Created by Lazy on 2018/8/14.
//

#import <Foundation/Foundation.h>

@interface FDBaseTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellClassArray;
@property (nonatomic, strong) NSDictionary *modelToCellClassMap;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)refreshData:(id)model;

@end
