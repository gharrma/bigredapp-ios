#import <UIKit/UIKit.h>


/** Responds to updates from a MasterDataSource */
@protocol MasterDataSourceDelegate

/** Update displayed cells to match data source. */
- (void)updateCells;

/** Report that a data update request failed. */
- (void)reportFetchError:(NSError *)error;

@end


@interface MasterViewController : UITableViewController <MasterDataSourceDelegate>

@end
