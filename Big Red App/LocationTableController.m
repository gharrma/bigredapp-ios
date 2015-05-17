#import "LocationTableController.h"
#import "MenuViewController.h"
#import "JSONRequests.h"
#import "Tools.h"
@import UIKit;


@interface LocationTableController () {
    NSArray *diningLocations;
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
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [Tools getCornellRed];
    [self.refreshControl addTarget:self action:@selector(getDiningLocations) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    [self getDiningLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Data updates

/** Get dining locations on a background thread, and reload view when finished. */
// TODO: Set a timout for requests
- (void)getDiningLocations {
    dispatch_async(BACKGROUND_THREAD, ^{
        NSError *error = nil;
        NSArray *locations = [JSONRequests fetchDiningHallLocations:&error];
        
        dispatch_async(APPLICATION_THREAD, ^{
            
            // Report error if applicable
            if (error) {
                NSLog(@"Fetch Error Reported: %@", [error localizedDescription]); // TODO :)
                [self.refreshControl endRefreshing];
            }
            
            // Update view if no error
            else {
                diningLocations = locations;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        });
    });
}

#pragma mark - Display and interaction

// Necessary to tell view how many cells to display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return diningLocations ? [diningLocations count] : 0;
}

// Return a particular cell to display.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Cells comes from the nib file.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *cellText = [self formatName:[diningLocations objectAtIndex:(int)indexPath.row]];
    cell.textLabel.text = cellText;
    
    return cell;
}

/** Remove underscores in a dining location name, and capitalize first letters. */
- (NSString *)formatName:(NSString *)name {
    
    // Keep certain names shorter, add in apostrophes, etc.
    // TODO: Choose better nicknames eventually
    NSDictionary *nicknames =
  @{@"104west":                            @"104west!",
    @"amit_bhatia_libe_cafe":              @"amit_bhatia's_libe_cafe",
    @"bears_den":                          @"bear's_den",
    @"carols_cafe":                        @"carol's_café",
    @"goldies":                            @"goldie's",
    @"jansens_dining_room_bethe_house":    @"bethe_house_dining_room",
    @"jansens_market":                     @"jansen's_market",
    @"marthas_cafe":                       @"martha's_cafe",
    @"north_star":                         @"north_star_dining_room",
    @"robert_purcell_marketplace_eatery":  @"robert_purcell_dining_room",
    @"rustys":                             @"rusty's"};
    NSString *nickname = [nicknames objectForKey:name];
    if (nickname) name = nickname;
    
    return [[[name  stringByReplacingOccurrencesOfString:@"_" withString:@" "]
                    stringByReplacingOccurrencesOfString:@"cafe" withString:@"café"]
                    capitalizedString];
}

// Prepare to transfer control to a menu view.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Give menu view the name of the dining location selected
        [[segue destinationViewController] setDiningLocation:[diningLocations objectAtIndex:(int)indexPath.row]];
    }
}

#pragma mark - Settings

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
