#import <Foundation/Foundation.h>

// Convenient names for application/background thread getters
#define BACKGROUND_THREAD (dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
#define APPLICATION_THREAD (dispatch_get_main_queue())


@interface JSONRequests : NSObject

/** Return a collection object representing the JSON object found at the given path.
    This should be called on a background thread! */
+ (id)fetchJsonObjectAtPath:(NSString *)path error:(NSError **)fetchError;

@end
