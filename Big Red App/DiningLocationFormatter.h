#import <Foundation/Foundation.h>

@interface DiningLocationFormatter : NSObject

+ (NSString *)getFormattedName:(NSString *)name;

+ (BOOL)isDiningRoom:(NSString *)name;

@end
