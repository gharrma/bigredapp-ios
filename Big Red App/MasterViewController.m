#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MasterDataSource.h"
@import UIKit;


@interface MasterViewController () {
    MasterDataSource *dataSource;
}
@end


@implementation MasterViewController

# pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
}

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [[MasterDataSource alloc] initWithDelegate:self];
    [dataSource requestDiningLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interaction

- (void)updateCells {
    [self.tableView reloadData];
}

- (void)reportFetchError:(NSError *)error {
    NSLog(@"Fetch Error Reported."); // TODO :)
}

// Return cells to display.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Cells comes from the nib file.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self formatName:[dataSource getNameForLocationIndex:(int)indexPath.row]];
    return cell;
}

/** Remove underscores in dining location names, and capitalize first letters. */
- (NSString *)formatName:(NSString *)name {
    return [[name stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
}

// Prepare to transfer control to a detail view.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:[dataSource getNameForLocationIndex:(int)indexPath.row]];
    }
}

#pragma mark - Settings

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource getLocationCount];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
