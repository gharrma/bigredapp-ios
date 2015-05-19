#import "LocationTableController.h"
#import "MenuViewController.h"
#import "JSONRequests.h"
#import "DiningLocationFormatter.h"
#import "Tools.h"
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
    [self.refreshControl beginRefreshing];
    
    [self requestDiningLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Data updates

/** Get dining locations on a background thread, and reload view when finished. */
// TODO: Set a timout for requests
- (void)requestDiningLocations {
    dispatch_async(BACKGROUND_THREAD, ^{
        NSError *error = nil;
        NSArray *locations = [JSONRequests fetchDiningHallLocations:&error];
        
        // Put each location identifier in the correct section (diningRooms vs. cafes)
        NSMutableArray *updatedDiningRooms = [NSMutableArray new], *updatedCafes = [NSMutableArray new];
        for (NSString *location in locations) {
            NSMutableArray *correctSection = [DiningLocationFormatter isDiningRoom:location] ? updatedDiningRooms : updatedCafes;
            [correctSection addObject:location];
        }
        
        // Sort locations alphabetically within each section
        NSArray *sortedDining, *sortedCafes;
        sortedDining = [updatedDiningRooms sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        sortedCafes = [updatedCafes sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        dispatch_async(APPLICATION_THREAD, ^{
            
            // Report error if applicable
            if (error) NSLog(@"Fetch Error Reported: %@", [error localizedDescription]); // TODO :)
            
            // Update view if no error
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

// Necessary to tell view how many cells to display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *locationType = section == 0 ? diningRooms : cafes;
    return locationType ? [locationType count] : 0;
}

// Return a particular cell to display.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Cells comes from the nib file.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location Cell" forIndexPath:indexPath];
    NSString *unformattedText = [(indexPath.section == 0 ? diningRooms : cafes) objectAtIndex:(int)indexPath.row];
    NSString *formattedText = [DiningLocationFormatter getFormattedName:unformattedText];
    cell.textLabel.text = formattedText;
    
    return cell;
}

// Prepare to transfer control to a menu view.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Give menu view the name of the dining location selected, which automatically requests its menu
        [[segue destinationViewController] setDiningLocation:[diningRooms objectAtIndex:(int)indexPath.row]];
    }
}

#pragma mark - Settings

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Dining Rooms" : @"Cafés and Cafeterias";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
