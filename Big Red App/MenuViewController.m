#import "MenuViewController.h"
#import "JSONRequests.h"
#import "Menu.h"
#import "Tools.h"

@interface MenuViewController () {
    NSString *diningLocation;
    UIRefreshControl *refreshControl;
}
@end

@implementation MenuViewController

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize pull-to-refresh
    refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor cornellRedColor];
    [refreshControl addTarget:self action:@selector(requestMenu) forControlEvents:UIControlEventValueChanged];
    [self.textView addSubview:refreshControl];
    [refreshControl beginRefreshing];
}

/** Select a new dining location, and request its menu. */
- (void)setDiningLocation:(NSString *)location {
    diningLocation = location;
    [self requestMenu];
}

/** Fetch the menu on a background thread, and update view when done. */
- (void)requestMenu {
    dispatch_async(BACKGROUND_THREAD, ^{
        
        // Fetch menu from API
        NSError *error = nil;
        NSDictionary *meals = [JSONRequests fetchMealsForLocation:diningLocation error:&error];
        
        // Fill text view with menu items
        NSString *menuText = meals ? [self stringFromMeals:meals] : nil;
        
        dispatch_async(APPLICATION_THREAD, ^{

            // Report error if applicable
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]); // TODO :)
                self.textView.text = [error localizedDescription];
            }
            
            // Update text
            else self.textView.text = menuText;
            
            [refreshControl endRefreshing];
        });
    });
}

/** Return a string from a dictionary of meals, listing one menu item per line. */
- (NSString *)stringFromMeals:(NSDictionary *)meals {
    NSMutableString *menuText = [NSMutableString new];
    for (Menu *meal in meals.allValues) {
        if (meal.closed) [menuText appendString:@"Closed\n"];
        else for (NSArray *group in meal.itemGroups.allValues) {
            for (NSString *item in group) {
                [menuText appendString:[NSString stringWithFormat:@"%@\n", item]];
            }
        }
        [menuText appendString:@"\n"];
    }
    
    return menuText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
