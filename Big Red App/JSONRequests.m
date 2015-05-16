#import "JSONRequests.h"

static NSString *const BASE_URL = @"http://redapi-tious.rhcloud.com/dining";


@implementation JSONRequests

+ (id)fetchJsonObjectAtPath:(NSString *)path error:(NSError **)fetchError {
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:path]]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) { // Network error
        *fetchError = error;
        return nil;
    }
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) { // JSON error
        *fetchError = error;
        return nil;
    }
    
    return jsonObject;
}

@end
