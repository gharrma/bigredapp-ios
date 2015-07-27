#import "CafeView.h"
#import "Tools.h"
#import "JSONRequests.h"


@interface CafeView () {
    UITextView *description, *menu;
}
@end

@implementation CafeView

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    description = [self formattedCellTextView];
    menu = [self formattedCellTextView];
    [self.refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Data Updates

- (void)showDetailForLocation:(NSString *)location {
    [super showDetailForLocation:location];
    [self requestData];
}

/** Fetch data on a background thread, and update view when done. */
- (void)requestData {
    dispatch_async(BACKGROUND_THREAD, ^{
        
        NSError *descriptionError = nil, *menuError = nil;
        NSString *descriptionText = [JSONRequests fetchDescriptionForLocation:locationID error:&descriptionError];
        NSString *menuText = [JSONRequests fetchMenuForCafeLocation:locationID error:&menuError useCache:NO];
        
        // Update view or report error
        dispatch_async(APPLICATION_THREAD, ^{
            if (menuError && descriptionError) {
                [self displayAlertForError:menuError withHandler:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
            if (menuError) menu.text = @"No menu found";
            else menu.text = menuText;
            
            if (descriptionError) description.text = @"No description found";
            else description.text = descriptionText;
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [activityIndicator stopAnimating];
        });
    });
}

#pragma mark - Display and interaction

// Provide a particular cell to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
    
    UITextView *textView = (indexPath.section == 0) ? menu : description;
    textView.frame = CGRectMake(cell.contentView.bounds.origin.x + DETAIL_TABLE_MARGIN,
                                cell.contentView.bounds.origin.y,
                                cell.contentView.bounds.size.width - DETAIL_TABLE_MARGIN * 2,
                                cell.contentView.bounds.size.height);
    [cell.contentView addSubview:textView];
    
    cell.backgroundColor = [UIColor cornellTanColor];
    return cell;
}

// Provide the height of a particular cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITextView *textView = (indexPath.section == 0) ? menu : description;
    CGSize size = [textView sizeThatFits:CGSizeMake(self.tableView.bounds.size.width - DETAIL_TABLE_MARGIN * 2, FLT_MAX)];
    return size.height;
}

// Provide number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Provide number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (menu && description) ? 2 : 0;
}

// Provide section titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Menu" : @"Description";
}

@end
