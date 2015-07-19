#import "DiningView.h"
#import "JSONRequests.h"
#import "Menu.h"
#import "Tools.h"
#import "LocationFormatter.h"
#import "ErrorHandling.h"

#define INITIAL_HEADER_HEIGHT 30.0
#define MEAL_HEADER_HEIGHT 50.0

#define MENU_ITEM_CELL_HEIGHT 20.0
#define CLOSED_CELL_HEIGHT 32.0
#define LOCATION_CELL_HEIGHT 45.0


static NSArray *meals;

@interface DiningView () {
    /** Dictionary of menus keyed with meal names. */
    NSDictionary *menus;
}
@end

@implementation DiningView

#pragma mark - Initialization

+ (void)initialize {
    meals = @[@"Breakfast", @"Lunch", @"Dinner"]; // TODO: Brunch?
}

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(requestMenu) forControlEvents:UIControlEventValueChanged];
}

- (void)showDetailForLocation:(NSString *)location {
    [super showDetailForLocation:location];
    [activityIndicator startAnimating];
    [self requestMenu];
}

#pragma mark - Data updates

/** Fetch the menu on a background thread, and update view when done. */
- (void)requestMenu {
    dispatch_async(BACKGROUND_THREAD, ^{
        
        // Fetch menu from API
        NSError *error = nil;
        NSDictionary *updatedMenus = [JSONRequests fetchMenusForLocation:locationID error:&error];
        
        // Update view or report error
        dispatch_async(APPLICATION_THREAD, ^{
            if (error) [ErrorHandling displayAlertForError:error fromViewController:self];
            else {
                menus = updatedMenus;
                [self.tableView reloadData];
                self.refreshControl.attributedTitle = [NSDate getLatestUpdateString];
            }
            
            [self.refreshControl endRefreshing];
            [activityIndicator stopAnimating];
        });
    });
}

#pragma mark - Display and interaction

// Provide a particular cell to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Menu *menu = [menus objectForKey:[meals objectAtIndex:(indexPath.section)]];
    NSString *cellType = menu.closed ? @"ClosedCell" : @"MenuItemCell";
    NSString *cellText = menu.closed ? @"Closed" : [menu menuItemForIndex:(int)indexPath.row].name;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    cell.textLabel.text = cellText;
    cell.textLabel.textColor = [UIColor cornellGrayColor];
    cell.backgroundColor = [UIColor cornellTanColor];
    
    return cell;
}

// Provide the height of a particular cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Menu *menu = [menus objectForKey:[meals objectAtIndex:(indexPath.section)]];
    return menu.closed ? CLOSED_CELL_HEIGHT : MENU_ITEM_CELL_HEIGHT;
}

// Provide number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Menu *menu = [menus objectForKey:[meals objectAtIndex:(section)]];
    return menu.closed ? 1 : [menu menuItemCount];
}

// Provide number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return menus ? [meals count] : 0;
}

// Provide section titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [meals objectAtIndex:(section)];
}

// Adjust section header heights
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? INITIAL_HEADER_HEIGHT : MEAL_HEADER_HEIGHT;
}

@end
