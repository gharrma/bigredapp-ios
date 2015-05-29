#import "MenuViewController.h"
#import "JSONRequests.h"
#import "Menu.h"
#import "Tools.h"
#import "LocationFormatter.h"
#import "ErrorHandling.h"

#define MENU_ITEM_CELL_HEIGHT 20.0
#define CLOSED_CELL_HEIGHT 32.0
#define LOCATION_CELL_HEIGHT 40.0
#define LOCATION_HEADER_HEIGHT 15.0
#define MEAL_HEADER_HEIGHT 35.0


@interface MenuViewController () {
    NSString *locationID, *locationName;
    
    /** List of meals offered at the selected location. */
    NSArray *meals;

    /** Dictionary of menus keyed with meal names. */
    NSDictionary *menus;
}
@end

@implementation MenuViewController

#pragma mark - Initialization

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    meals = @[@"Breakfast", @"Lunch", @"Dinner"]; // TODO: Brunch?
    
    // Initialize pull-to-refresh
    self.refreshControl.tintColor = [UIColor cornellRedColor];
    [self.refreshControl addTarget:self action:@selector(requestMenu) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = nil;
}

- (void)showMenuForLocation:(NSString *)location {
    locationID = location;
    locationName = [LocationFormatter formatLocationName:locationID];
    [self.refreshControl beginRefreshing];
    [self requestMenu];
}

#pragma mark - Data updates

/** Fetch the menu on a background thread, and update view when done. */
- (void)requestMenu {
    dispatch_async(BACKGROUND_THREAD, ^{
        
        // Fetch menu from API
        NSDictionary *updatedMenus = nil;
        NSError *error = nil;
        // TODO: Display description of café rather than an error
        if (![LocationFormatter isDiningRoom:locationID]) error = [NSError noMenuFound];
        else updatedMenus = [JSONRequests fetchMenusForLocation:locationID error:&error];
        
        // Update view or report error
        dispatch_async(APPLICATION_THREAD, ^{
            if (error) [ErrorHandling displayAlertForError:error fromViewController:self];
            else {
                menus = updatedMenus;
                [self.tableView reloadData];
                self.refreshControl.attributedTitle = [NSDate getLatestUpdateString];
            }
            
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Display and interaction

// Provide a particular cell to display.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType, *cellText, *detailText;
    
    if (indexPath.section == 0) {
        cellType = @"LocationNameCell";
        cellText = locationName;
    } else {
        Menu *menu = [menus objectForKey:[meals objectAtIndex:(indexPath.section - 1)]];
        cellType = menu.closed ? @"ClosedCell" : @"MenuItemCell";
        cellText = menu.closed ? @"Closed" : [menu menuItemForIndex:(int)indexPath.row].name;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

// Provide the height of a particular cell.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return LOCATION_CELL_HEIGHT;
    Menu *menu = [menus objectForKey:[meals objectAtIndex:(indexPath.section - 1)]];
    return menu.closed ? CLOSED_CELL_HEIGHT : MENU_ITEM_CELL_HEIGHT;
}

// Provide number of cells.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    Menu *menu = [menus objectForKey:[meals objectAtIndex:(section - 1)]];
    return menu.closed ? 1 : [menu menuItemCount];
}

// Provide number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (menus ? [meals count] : 0) + 1;
}

// Provide section titles.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    return [meals objectAtIndex:(section - 1)];
}

// Adjust section header colors.
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = [UIColor whiteColor];
    [header.textLabel setTextColor:[UIColor cornellRedColor]];
}

// Adjust section header heights.
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? LOCATION_HEADER_HEIGHT : MEAL_HEADER_HEIGHT;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
