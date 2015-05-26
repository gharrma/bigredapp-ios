#import "JSONRequests.h"
#import "Tools.h"
#import "Menu.h"
#import "ErrorHandling.h"

static NSString *const BASE_URL = @"http://redapi-tious.rhcloud.com/";
static int const TIMEOUT_INTERVAL = 10;


@implementation JSONRequests

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

+ (NSArray *)fetchDiningHallLocations:(NSError **)error {
    NSArray *locations = [self fetchJsonObjectAtPath:@"dining" error:error];
    if (*error) return nil;
    
    if (![locations isKindOfClass:[NSArray class]] || [locations count] == 0) {
        *error = [NSError jsonError];
        return nil;
    }
    
    return locations;
}

+ (NSDictionary *)fetchMenusForLocation:(NSString *)location error:(NSError **)error {
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

@end
