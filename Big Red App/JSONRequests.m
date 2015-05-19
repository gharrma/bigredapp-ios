#import "JSONRequests.h"
#import "Tools.h"
#import "Menu.h"

static NSString *const BASE_URL = @"http://redapi-tious.rhcloud.com/dining";
static int const TIMEOUT_LENGTH = 10;


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

/** Get a dictionary filled with the three menus for the day for a particular location. 
    The dictionary returned contains entries */
+ (NSDictionary *)fetchMealsForLocation:(NSString *)location error:(NSError **)error {
    NSString *path = [NSString stringWithFormat:@"/menu/%@/Breakfast,Lunch,Dinner/LOCATIONS", location];
    NSDictionary *baseObject = [self fetchJsonObjectAtPath:path error:error];
    if (*error) return nil; // JSON error
    
    NSDictionary *locationData = [baseObject objectForKey:location];
    if (!locationData) {
        *error = [NSError errorWithDomain:JSON_ERROR code:1 userInfo:nil];
        return nil;
    }
    
    NSMutableDictionary *meals = [NSMutableDictionary new];
    for (NSString *meal in @[@"Breakfast", @"Lunch", @"Dinner"]) {
        Menu *menu = [self buildMenuFromArray:[locationData objectForKey:meal] error:error];
        if (*error) return nil;
        [meals setValue:menu forKey:meal];
    }
    
    return meals;
}

/** Create a meal object from a json-sourced array of menu items. */
+ (Menu *)buildMenuFromArray:(NSArray *)items error:(NSError **)error {
    if (!items || [items isKindOfClass:[NSNull class]]) {
        // No menu found
        *error = [NSError errorWithDomain:NO_MENU_FOUND code:0 userInfo:nil];
        return nil;
    }
    
    Menu *menu = [Menu new];
    for (NSDictionary *item in items) {
        // TODO: Could do more nit-picky error checking here
        NSString *category = [item objectForKey:@"category"];
        NSString *name = [item objectForKey:@"name"];
        
        if ([name isEqualToString:@"Closed"]) {
            menu.closed = true;
            return menu;
        }
        
        NSMutableArray *itemGroup = [menu.itemGroups objectForKey:category];
        if (!itemGroup) {
            itemGroup = [NSMutableArray new];
            [menu.itemGroups setValue:itemGroup forKey:category];
        }
        
        [itemGroup addObject:name];
    }
    
    return menu;
}

/** Return a collection object representing the JSON object found at the given path appended to base URL.
    This should be called while on a background thread! Precondition: error is initially null. */
+ (id)fetchJsonObjectAtPath:(NSString *)path error:(NSError **)error {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:path]]
                                             cachePolicy:0
                                         timeoutInterval:TIMEOUT_LENGTH];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (*error) return nil; // Network error
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (*error) return nil; // JSON error
    
    return jsonObject;
}

@end
