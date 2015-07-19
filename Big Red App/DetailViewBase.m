#import "DetailViewBase.h"
#import "LocationFormatter.h"
#import "Tools.h"

#define TABLE_HEADER_HEIGHT 110.0


@implementation DetailViewBase

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor cornellTanColor];
}

- (void)showDetailForLocation:(NSString *)location {
    locationID = location;
    locationName = [LocationFormatter formatLocationName:locationID];
    
    // Header
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, TABLE_HEADER_HEIGHT)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor cornellGrayColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:30.0];
    headerLabel.adjustsFontSizeToFitWidth = YES;
    headerLabel.text = locationName;
    self.tableView.tableHeaderView = headerLabel;
    
    // Activity indicator
    activityIndicator = [UIActivityIndicatorView new];
    activityIndicator.center = CGPointMake(self.view.bounds.size.width / 2.0,
                                           self.view.bounds.size.height / 2.0
                                            - self.navigationController.navigationBar.bounds.size.height
                                            - TABLE_HEADER_HEIGHT / 2.0);
    activityIndicator.color = [UIColor cornellGrayColor];
    [self.view addSubview:activityIndicator];
    
    // (Override for further setup(
}

// Adjust section header style
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [header.textLabel setTextColor:[UIColor cornellRedColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
