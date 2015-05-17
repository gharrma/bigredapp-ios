#import <Foundation/Foundation.h>

// Convenient names for application/background thread getters
#define BACKGROUND_THREAD (dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
#define APPLICATION_THREAD (dispatch_get_main_queue())

// Useful error identifiers
#define JSON_ERROR (@"JSON Error")
#define NETWORK_ERROR (@"Network Error")


@interface JSONRequests : NSObject

+ (NSArray *)fetchDiningHallLocations:(NSError **)fetchError;

@end
