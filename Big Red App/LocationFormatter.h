#import <Foundation/Foundation.h>

@interface LocationFormatter : NSObject

+ (NSString *)formatLocationName:(NSString *)name;

+ (BOOL)isDiningRoom:(NSString *)name;

@end
