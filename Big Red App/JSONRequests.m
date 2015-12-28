#import "JSONRequests.h"
#import "Tools.h"
#import "DiningView.h"


#pragma mark - Custom Errors

static NSString
*const JSON_ERROR_MESSAGE = @"There seems to be an issue with the server--hopefully a temporary one. You may try swiping down to refresh.",
*const NO_MENU_MESSAGE = @"We cannot find a menu for this location.",
*const NO_DESCRIPTION_FOUND_MESSAGE = @"We cannot find a description for this location.",
*const NO_SHORT_DESCRIPTION_FOUND_MESSAGE = @"We cannot find a short description for this location.";

@implementation NSError (ExtraErrors)
+ (NSError *)jsonError {
    return [NSError errorWithDomain:@"JSON" code:0 userInfo:@{NSLocalizedDescriptionKey: JSON_ERROR_MESSAGE}];
}
+ (NSError *)noMenuFound {
    return [NSError errorWithDomain:@"Menu" code:0 userInfo:@{NSLocalizedDescriptionKey: NO_MENU_MESSAGE}];
}
+ (NSError *)noDescriptionFound {
    return [NSError errorWithDomain:@"Data" code:0 userInfo:@{NSLocalizedDescriptionKey: NO_DESCRIPTION_FOUND_MESSAGE}];
}
+ (NSError *)noShortDescriptionFound {
    return [NSError errorWithDomain:@"Data" code:0 userInfo:@{NSLocalizedDescriptionKey: NO_SHORT_DESCRIPTION_FOUND_MESSAGE}];
}
@end


#pragma mark - Requests

static NSString *const BASE_URL = @"https://redapi-tious.rhcloud.com/";
#define TIMEOUT_INTERVAL 10
#define HALF_HOUR_IN_SECONDS 1800.0

static NSMutableDictionary *menuCache = nil, *menuCacheTimeStamps = nil;
static NSDictionary *locationData = nil;

@implementation JSONRequests

+ (void)initialize {
    menuCache = [NSMutableDictionary new];
    menuCacheTimeStamps = [NSMutableDictionary new];
}

/** Return a collection object representing the JSON object found at the given path appended to base URL.
    This should be called while on a background thread! Precondition: error is initially null. */
+ (id)fetchJsonObjectAtPath:(NSString *)path error:(NSError **)error {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:path]]
                                             cachePolicy:0
                                         timeoutInterval:TIMEOUT_INTERVAL];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (*error) return nil; // Network error
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (*error) return nil; // JSON error
    
    #ifdef DEBUG
    NSLog(@"JSON object fetched:\n%@\n", jsonObject);
    #endif
    
    return jsonObject;
}

+ (NSArray *)fetchDiningLocations:(NSError **)error {
    NSArray *locations = [self fetchJsonObjectAtPath:@"dining" error:error];
    if (*error) return nil;
    
    if (![locations isKindOfClass:[NSArray class]] || [locations count] == 0) {
        *error = [NSError jsonError];
        return nil;
    }
    
    return locations;
}

+ (NSDictionary *)fetchMenusForDiningLocation:(NSString *)location error:(NSError **)error useCache:(BOOL)useCache {
    NSDictionary *cached = [menuCache objectForKey:location];
    if (useCache && cached) {
        NSTimeInterval cachedAge = ABS([[menuCacheTimeStamps objectForKey:location] timeIntervalSinceNow]);
        if (cachedAge < HALF_HOUR_IN_SECONDS) return cached;
    }
    
    NSString *path = [NSString stringWithFormat:@"dining/menu/%@/Breakfast,Lunch,Dinner/LOCATIONS", location];
    NSDictionary *baseObject = [self fetchJsonObjectAtPath:path error:error];
    if (*error) return nil;
    
    NSDictionary *locationData = [baseObject objectForKey:location];
    if (!locationData) {
        *error = [NSError jsonError];
        return nil;
    }
    
    NSMutableDictionary *menus = [NSMutableDictionary new];
    for (NSString *meal in @[@"Breakfast", @"Lunch", @"Dinner"]) { // TODO: Brunch?
        Menu *menu = [self buildMenuFromJSONArray:[locationData objectForKey:meal] error:error];
        if (*error) return nil;
        [menus setValue:menu forKey:meal];
    }
    
    NSDate *now = [NSDate date];
    [menus setObject:now forKey:@"Date"];
    [menuCacheTimeStamps setObject:now forKey:location];
    [menuCache setValue:menus forKey:location];
    return menus;
}

/** Create a meal object from a json-sourced array of menu items. */
+ (Menu *)buildMenuFromJSONArray:(NSArray *)items error:(NSError **)error {
    Menu *menu = [Menu new];
    
    // If no menu found, assume closed for the current meal
    if (!items || [items isKindOfClass:[NSNull class]]) {
        menu.closed = true;
        return menu;
    }
    
    for (NSDictionary *item in items) {
        NSString *category = [item objectForKey:@"category"];
        NSString *name = [item objectForKey:@"name"];
        
        if (!category) category = @"[Uncategorized]";
        if (!name) continue;
        if ([name isEqualToString:@"Closed"]) {
            menu.closed = true;
            return menu;
        }
        
        [menu addMenuItem:[[MenuItem alloc] initWithName:name category:category]];
    }
    
    return menu;
}

+ (NSString *)fetchMenuForCafeLocation:(NSString *)location error:(NSError **)error useCache:(BOOL)useCache {
    NSString *menu = [self getLocationData:@"menu" forLocation:location];
    
    if (!menu) {
        *error = [NSError noMenuFound];
        return nil;
    }
    
    return menu;
}

+ (NSString *)fetchShortDescriptionForLocation:(NSString *)location error:(NSError **) error {
    NSString *shortDescription = [self getLocationData:@"what" forLocation:location];
    
    if (!shortDescription) {
        * error = [NSError noShortDescriptionFound];
        return nil;
    }
    
    return shortDescription;
}

+ (NSString *)fetchDescriptionForLocation:(NSString *)location error:(NSError **)error {
    NSString *description = [self getLocationData:@"description" forLocation:location];
    
    if (!description) {
        *error = [NSError noDescriptionFound];
        return nil;
    }
    
    return [NSString stringWithFormat:@"\"%@\"\n\n\t - Cornell Dining", description];
}

+ (NSString *)getLocationData:(NSString *)key forLocation:(NSString *)location {
    if (!locationData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LocationData" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error = nil;
        locationData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) return nil;
    }
    
    NSDictionary *specificLocation = [locationData objectForKey:location];
    if (!specificLocation) return nil;
    
    NSString *ret = [specificLocation objectForKey:key];
    return ret;
}

+ (void)clearCache {
    [menuCache removeAllObjects];
    [menuCacheTimeStamps removeAllObjects];
    locationData = nil;
}

@end
