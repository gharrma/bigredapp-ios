#import "LocationTable.h"
#import "DiningView.h"
#import "JSONRequests.h"
#import "LocationFormatter.h"
#import "Tools.h"
#import "ErrorHandling.h"
@import UIKit;

#define DINING_CELL_HEIGHT 58.0
#define CAFE_CELL_HEIGHT 48.0


@interface LocationTable () {
    NSArray *diningRooms, *cafes;
}
@end

@implementation LocationTable

# pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
}

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(requestDiningLocations) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self requestDiningLocations];
}

# pragma mark - Data updates

/** Get dining locations on a background thread, and reload view when finished. */
- (void)requestDiningLocations {
    dispatch_async(BACKGROUND_THREAD, ^{
        NSError *error = nil;
        NSArray *locations = [JSONRequests fetchDiningLocations:&error];
        
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
    NSString *cellType = (indexPath.section == 0) ? @"DiningCell" : @"CafeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    NSString *unformattedText = [(indexPath.section == 0 ? diningRooms : cafes) objectAtIndex:(int)indexPath.row];
    NSString *formattedText = [LocationFormatter formatLocationName:unformattedText];
    cell.textLabel.text = formattedText;
    cell.textLabel.textColor = [UIColor cornellGrayColor];
    cell.detailTextLabel.textColor = [UIColor cornellGrayColor];
    
    return cell;
}

// Prepare to transfer control to a menu view.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSArray *locationType = indexPath.section == 0 ? diningRooms : cafes;
    NSString *location = [locationType objectAtIndex:(int)indexPath.row];
    [[segue destinationViewController] showDetailForLocation:location];
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

// Provide the height of a particular cell.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? DINING_CELL_HEIGHT : CAFE_CELL_HEIGHT;
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
