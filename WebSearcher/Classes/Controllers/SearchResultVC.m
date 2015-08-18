//
//  SearchResultVC.m
//  WebSearcher
//
//  Created by  Nechet Oleksandr on 16.08.15.
//  Copyright (c) 2015  Nechet Oleksandr. All rights reserved.
//

#import "SearchResultVC.h"
#import "SearchManager.h"
#import "Result.h"

@interface SearchResultVC () <UITableViewDataSource, UITableViewDelegate, SearchManagerDelegate>
{
    __weak IBOutlet UITableView *tableViewContent;
}

@end

@implementation SearchResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SearchManager shareManager].delegate = self;
}

- (IBAction)stop:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[SearchManager shareManager] stop];
    }else{
        [[SearchManager shareManager] startSearching];
    }
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    Result *r = [SearchManager shareManager].searchResult[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (indexPath.row + 1), r.urlString];
    cell.detailTextLabel.text = r.status;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SearchManager shareManager].searchResult.count;
}

#pragma mark - SearchManager Delegate

- (void)didUpdateData
{
    [tableViewContent reloadData];
}

@end
