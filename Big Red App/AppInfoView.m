#import "AppInfoView.h"
#import "Tools.h"

@interface AppInfoView () {
    NSArray *sectionHeaders;
    NSMutableArray *sectionViews;
}
@end

@implementation AppInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showDetailFor:@"Big Red App" withHeaderDetail:NO];
    
    sectionHeaders = @[@"Info", @"Credits"];
    sectionViews = [NSMutableArray array];
    for (NSString *sectionHeader in sectionHeaders) {
        UITextView *textView = [self formattedCellTextView];

        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"App%@", sectionHeader] ofType:@"rtf"];
        NSAttributedString *text = [[NSAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:path]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType}
                                                            documentAttributes:nil
                                                                         error:&error];
        if (error) textView.text = @"[error]";
        else textView.attributedText = text;
        
        [sectionViews addObject:textView];
    }
}

// Provide a particular cell to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
    
    UITextView *textView = [sectionViews objectAtIndex:indexPath.section];
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
    UITextView *textView = [sectionViews objectAtIndex:indexPath.section];
    CGSize size = [textView sizeThatFits:CGSizeMake(self.tableView.bounds.size.width - DETAIL_TABLE_MARGIN * 2, FLT_MAX)];
    return size.height;
}

// Provide number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Provide number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionHeaders count];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [super tableView:tableView willDisplayHeaderView:view forSection:section];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

// Provide section titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionHeaders objectAtIndex:section];
}

@end
