#import <Foundation/Foundation.h>
@class Meals;


/** Provides methods for getting and encapsulating data from the RedAPI. 
    All fetch requests should be made on a background thread. */
@interface JSONRequests : NSObject

/** Returns an array of strings corresponding to dining locations. */
+ (NSArray *)fetchDiningLocations:(NSError **)fetchError;

/** Returns a dictionary filled with all menus for the day for a particular location.
    The dictionary is keyed with meal names (e.g., "Breakfast"). */
+ (NSDictionary *)fetchMenusForLocation:(NSString *)location error:(NSError **)error;

+ (void)clearCache;

@end
