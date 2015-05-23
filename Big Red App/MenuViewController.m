#import "MenuViewController.h"
#import "JSONRequests.h"
#import "Menu.h"
#import "Tools.h"
#import "LocationFormatter.h"

#define MENU_ITEM_CELL_HEIGHT 20
#define CLOSED_CELL_HEIGHT 32


@interface MenuViewController () {
    NSString *diningLocation;
    
    /** List of meals offered at the selected location. */
    NSArray *meals;

    /** Dictionary of menus keyed with meal names. */
    NSDictionary *menus;
}
@end

@implementation MenuViewController

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
    diningLocation = location;
    [self.refreshControl beginRefreshing];
    [self requestMenu];
}

/** Fetch the menu on a background thread, and update view when done. */
- (void)requestMenu {
    dispatch_async(BACKGROUND_THREAD, ^{
        
        // Fetch menu from API
        NSError *error = nil;
        menus = [JSONRequests fetchMenusForLocation:diningLocation error:&error];
        
        // Update view or report error
        dispatch_async(APPLICATION_THREAD, ^{
            if (error) NSLog(@"Error: %@", [error localizedDescription]); // TODO :)
            else {
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
    Menu *menu = [menus objectForKey:[meals objectAtIndex:indexPath.section]];
    NSString *cellType = menu.closed ? @"ClosedCell" : @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    cell.textLabel.text = menu.closed ? @"Closed" : [menu menuItemForIndex:(int)indexPath.row].name;
    
    return cell;
}

// Provide the height of a particular cell.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Menu *menu = [menus objectForKey:[meals objectAtIndex:indexPath.section]];
    return menu.closed ? CLOSED_CELL_HEIGHT : MENU_ITEM_CELL_HEIGHT;
}

// Provide number of cells.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Menu *menu = [menus objectForKey:[meals objectAtIndex:section]];
    return menu.closed ? 1 : [menu menuItemCount];
}

// Provide number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return menus ? [meals count] : 0;
}

// Provide section titles.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [meals objectAtIndex:section];
}

// Adjust section header colors.
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = [UIColor whiteColor];
    [header.textLabel setTextColor:[UIColor cornellRedColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
