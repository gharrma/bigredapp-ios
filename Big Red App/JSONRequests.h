#import <Foundation/Foundation.h>
@class Meals;


/** Provide methods for getting and encapsulating data from the RedAPI.
    All fetch requests should be made on a background thread. */
@interface JSONRequests : NSObject

/** Return an array of strings corresponding to dining locations. */
+ (NSArray *)fetchDiningLocations:(NSError **)fetchError;

/** Return a dictionary filled with all menus for the day for a particular location.
    The dictionary is keyed with meal names (e.g., "Breakfast"). The special key "Date" is mapped
    to an NSData object representing the time at which the menus were fetched. */
+ (NSDictionary *)fetchMenusForDiningLocation:(NSString *)location error:(NSError **)error useCache:(BOOL)useCache;

/** Return a string containing the menu for the given café. */
+ (NSString *)fetchMenuForCafeLocation:(NSString *)location error:(NSError **)error useCache:(BOOL)useCache;

/** Return a very short description for the given location, or raise an error if not found. */
+ (NSString *)fetchShortDescriptionForLocation:(NSString *)location error:(NSError **) error;

/** Return a description for the given location, or raise an error if not found. */
+ (NSString *)fetchDescriptionForLocation:(NSString *)location error:(NSError **)error;

+ (void)clearCache;

@end
