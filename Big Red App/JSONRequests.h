#import <Foundation/Foundation.h>
@class Meals;

@interface JSONRequests : NSObject

/** Returns an array of strings corresponding to dining locations. */
+ (NSArray *)fetchDiningHallLocations:(NSError **)fetchError;

/** Returns a dictionary filled with all menus for the day for a particular location.
    The dictionary is keyed with meal names (e.g., "Breakfast"). */
+ (NSDictionary *)fetchMenusForLocation:(NSString *)location error:(NSError **)error;

@end
