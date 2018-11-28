//
//  BPWBaseTableViewDelegate.m
//  FDKit
//
//  Created by Lazy on 2018/8/14.
//

#import "FDBaseTableViewDelegate.h"
#import "FDTableViewCellProtocol.h"

#import "FDCategoriesMacro.h"
#import "NSArray+FDAdd.h"
#import "FDTableViewCellProtocol.h"

@implementation FDBaseTableViewDelegate
- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self && tableView) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self registerViews];
    }
    return self;
}

- (void)registerViews {
    @weakify(self)
    [self.cellClassArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [self.tableView registerNib:FDNibWithClassName(NSStringFromClass(obj)) forCellReuseIdentifier:FDIdentifierWithViewName(NSStringFromClass(obj))];
    }];
}

- (void)refreshData:(id)model {
    self.dataArray = model;
    [self.tableView reloadData];
}

#pragma -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray fd_objectOrNilAtIndex:section] count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id model = [[self.dataArray fd_objectOrNilAtIndex:indexPath.section] fd_objectOrNilAtIndex:indexPath.row];
    Class cellClass = [self.modelToCellClassMap valueForKey: NSStringFromClass([model class])];
    NSString *identifier = FDIdentifierWithViewName(NSStringFromClass(cellClass));
    UITableViewCell<FDDataViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setViewWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    id model = [[self.dataArray fd_objectOrNilAtIndex:indexPath.section] fd_objectOrNilAtIndex:indexPath.row];
    Class cellClass = [self.modelToCellClassMap valueForKey: NSStringFromClass([model class])];
    height = [cellClass cellHeight];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
