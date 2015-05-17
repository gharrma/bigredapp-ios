#import "JSONRequests.h"
#import "Tools.h"

static NSString *const BASE_URL = @"http://redapi-tious.rhcloud.com/dining";


/** Provides methods for getting data from the RedAPI. */
@implementation JSONRequests

+ (NSArray *)fetchDiningHallLocations:(NSError **)error {
    NSArray *locations = [self fetchJsonObjectAtPath:@"" error:error];
    if (*error) return nil;
    
    // JSON error
    if (![locations isKindOfClass:[NSArray class]] || [locations count] == 0) {
        *error = [NSError errorWithDomain:JSON_ERROR code:0 userInfo:nil];
        return nil;
    }
    
    return locations;
}

/** Return a collection object representing the JSON object found at the given path appended to base URL.
    This should be called on a background thread! Precondition: error is initially null. */
+ (id)fetchJsonObjectAtPath:(NSString *)path error:(NSError **)error {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:path]]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (*error) return nil; // Network error
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (*error) return nil; // JSON error
    
    return jsonObject;
}

@end
