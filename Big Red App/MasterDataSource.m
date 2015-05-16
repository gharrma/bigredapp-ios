#import "MasterDataSource.h"
#import "MasterViewController.h"
#import "JSONRequests.h"


@interface MasterDataSource () {
    NSObject<MasterDataSourceDelegate> __weak *delegate;
    NSArray *diningLocations;
}

@end


@implementation MasterDataSource

- (id)initWithDelegate:(NSObject<MasterDataSourceDelegate> *)view {
    self = [super init];
    delegate = view;
    diningLocations = [NSArray new];
    return self;
}

- (void)requestDiningLocations {
    dispatch_async(BACKGROUND_THREAD, ^{
        NSError *error = nil;
        NSArray *names = [JSONRequests fetchJsonObjectAtPath:@"" error:&error];
        
        if (error || ![names isKindOfClass:[NSMutableArray class]]) {
            dispatch_async(APPLICATION_THREAD, ^{
                [delegate reportFetchError:error];
            });
            return;
        }
        
        diningLocations = names;
        dispatch_async(APPLICATION_THREAD, ^{
            [delegate updateCells];
        });
    });
}

- (int)getLocationCount {
    return [diningLocations count];
}

- (NSString *)getNameForLocationIndex:(int)cell {
    return [diningLocations objectAtIndex:cell];
}

@end
