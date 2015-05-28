#import "LocationTableController.h"
#import "MenuViewController.h"
#import "JSONRequests.h"
#import "LocationFormatter.h"
#import "Tools.h"
#import "ErrorHandling.h"
@import UIKit;


@interface LocationTableController () {
    NSArray *diningRooms, *cafes;
}
@end

@implementation LocationTableController

# pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
}

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize pull-to-refresh
    [self.refreshControl addTarget:self action:@selector(requestDiningLocations) forControlEvents:UIControlEventValueChanged];
    
    // Get dining locations
    [self.refreshControl beginRefreshing];
    [self requestDiningLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Data updates

/** Get dining locations on a background thread, and reload view when finished. */
- (void)requestDiningLocations {
    dispatch_async(BACKGROUND_THREAD, ^{
        NSError *error = nil;
        NSArray *locations = [JSONRequests fetchDiningHallLocations:&error];
        
        // Put each location identifier in the correct section (diningRooms vs. cafes)
        NSMutableArray *updatedDiningRooms = [NSMutableArray new], *updatedCafes = [NSMutableArray new];
        for (NSString *location in locations) {
            NSMutableArray *correctSection = [LocationFormatter isDiningRoom:location] ? updatedDiningRooms : updatedCafes;
            [correctSection addObject:location];
        }
        
        // Sort locations alphabetically within each section. TODO: Unfortunately, this does not sort by nickname
        NSArray *sortedDining, *sortedCafes;
        sortedDining = [updatedDiningRooms sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        sortedCafes = [updatedCafes sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Update view or report error
        dispatch_async(APPLICATION_THREAD, ^{
            if (error) [ErrorHandling displayAlertForError:error fromViewController:self];
            else {
                diningRooms = sortedDining;
                cafes = sortedCafes;
                [self.tableView reloadData];
                
                // Show latest update time
                self.refreshControl.attributedTitle = [NSDate getLatestUpdateString];
            }
            
            [self.refreshControl endRefreshing];
        });
    });
}

#pragma mark - Display and interaction

// Return a particular cell to display.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Cells comes from the nib file.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location Cell" forIndexPath:indexPath];
    NSString *unformattedText = [(indexPath.section == 0 ? diningRooms : cafes) objectAtIndex:(int)indexPath.row];
    NSString *formattedText = [LocationFormatter formatLocationName:unformattedText];
    cell.textLabel.text = formattedText;
    
    cell.detailTextLabel.text = @"Placeholder detail";
    cell.detailTextLabel.textColor = [UIColor cornellRedColor];
    
    return cell;
}

// Prepare to transfer control to a menu view.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowMenu"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *locationType = indexPath.section == 0 ? diningRooms : cafes;
        [[segue destinationViewController] showMenuForLocation:[locationType objectAtIndex:(int)indexPath.row]];
    }
}

// Deselect selected cell when returning to this view
- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}

// Provide number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *locationType = section == 0 ? diningRooms : cafes;
    return locationType ? [locationType count] : 0;
}

// Provide number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (diningRooms && cafes) ? 2 : 0;
}

// Provide section titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Dining Rooms" : @"Cafés and Cafeterias";
}

// Adjust section header colors
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
