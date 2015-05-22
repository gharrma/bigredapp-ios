#import <Foundation/Foundation.h>

@interface LocationFormatter : NSObject

/** Remove underscores in a dining location name, capitalize first letters, and map to nicknames if applicable. */
+ (NSString *)formatLocationName:(NSString *)name;

/** Returns true iff the given dining location is a dining room (as opposed to a café, etc.) */
+ (BOOL)isDiningRoom:(NSString *)name;

@end
