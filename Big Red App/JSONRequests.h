#import <Foundation/Foundation.h>
@class Meals;

@interface JSONRequests : NSObject

+ (NSArray *)fetchDiningHallLocations:(NSError **)fetchError;
+ (NSDictionary *)fetchMealsForLocation:(NSString *)location error:(NSError **)error;

@end
