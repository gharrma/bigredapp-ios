#import "DetailViewBase.h"
#import "NameFormatter.h"
#import "Tools.h"

#define TABLE_HEADER_MARGIN 50.0
#define TABLE_HEADER_HEIGHT 110.0
#define TABLE_HEADER_FONT_SIZE 30.0
#define INITIAL_HEADER_HEIGHT 30.0
#define NORMAL_HEADER_HEIGHT 50.0


@implementation DetailViewBase

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor cornellTanColor];
}

#pragma mark - Display and Interaction

- (void)showDetailForLocation:(NSString *)location {
    locationID = location;
    locationName = [NameFormatter formatLocationName:locationID];
    
    // Header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, TABLE_HEADER_HEIGHT)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(TABLE_HEADER_MARGIN,
                                                                     0.0,
                                                                     self.tableView.bounds.size.width - TABLE_HEADER_MARGIN * 2,
                                                                     TABLE_HEADER_HEIGHT)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor cornellGrayColor];
    headerLabel.backgroundColor = [UIColor cornellTanColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:TABLE_HEADER_FONT_SIZE];
    headerLabel.adjustsFontSizeToFitWidth = YES;
    headerLabel.text = locationName;
    [headerView addSubview:headerLabel];
    self.tableView.tableHeaderView = headerView;
    
    // Activity indicator
    activityIndicator = [UIActivityIndicatorView new];
    activityIndicator.center = CGPointMake(self.view.bounds.size.width / 2.0,
                                           self.view.bounds.size.height / 2.0
                                            - self.navigationController.navigationBar.bounds.size.height
                                            - TABLE_HEADER_HEIGHT / 2.0);
    activityIndicator.color = [UIColor cornellGrayColor];
    [self.view addSubview:activityIndicator];
}

// Adjust section header style
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [header.textLabel setTextColor:[UIColor cornellRedColor]];
}

- (UITextView *)formattedCellTextView {
    UITextView *textView = [UITextView new];
    textView.textColor = [UIColor cornellGrayColor];
    textView.backgroundColor = [UIColor cornellTanColor];
    textView.font = [UIFont systemFontOfSize:16.0];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.selectable = NO;
    return textView;
}

// Adjust section header heights
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? INITIAL_HEADER_HEIGHT : NORMAL_HEADER_HEIGHT;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
