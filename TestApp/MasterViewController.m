//
//  MasterViewController.m
//  TestApp
//
//  Created by David Muzi on 2014-12-29.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import <DMDiskStation/DMDiskStation.h>

@interface MasterViewController () <DMDiskStationSessionDelegate>

@property NSMutableArray *objects;

@property (nonatomic, strong) DMDiskStationSession *session;
@property (nonatomic, strong) DMFileStationAPI *api;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [[DMDiskStationSession alloc] initWithDelegate:self];
    
    if (_session.isSessionActive == NO) {
        [_session showLoginFromViewController:self.navigationController];
    }
    else {
        
        [self updateFileList];
    }
}

- (void)updateFileList {
    _api = [[DMFileStationAPI alloc] initWithSession:_session];
    [_api fileListForPath:nil callback:^(NSError *error, NSArray *files) {
        
        _objects = files.mutableCopy;
        [self.tableView reloadData];
        
    }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    DMFile *file = self.objects[indexPath.row];
    cell.textLabel.text = file.name;
    return cell;
}

#pragma mark - DMDiskStationSessionDelegate

- (void)session:(DMDiskStationSession *)session didLogin:(BOOL)success {
    
    if (success) {
        [self updateFileList];
    }
}

@end
