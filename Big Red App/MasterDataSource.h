#import <Foundation/Foundation.h>
@protocol MasterDataSourceDelegate;


/** Keep track of and serves data needed to populate cells in the master table view. */
@interface MasterDataSource : NSObject

- (id)initWithDelegate:(NSObject<MasterDataSourceDelegate> *)view;

// Update list of dining locations and notify view controller when finished.
- (void)requestDiningLocations;

/** Return the name for a particular dining location. */
- (NSString *)getNameForLocationIndex:(int)cell;

- (int)getLocationCount;

@end
