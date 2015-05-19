#import "DiningLocationFormatter.h"

@implementation DiningLocationFormatter

/** Remove underscores in a dining location name, capitalize first letters, and map to nicknames if applicable. */
+ (NSString *)getFormattedName:(NSString *)name {
    
    NSDictionary *const nicknames =
    @{@"becker_house_dining_room":          @"Becker",
      @"cook_house_dining_room":            @"Cook",
      @"jansens_dining_room_bethe_house":   @"Bethe",
      @"keeton_house_dining_room":          @"Keeton",
      @"north_star":                        @"North Star (Appel)",
      @"okenshields":                       @"Okenshields",
      @"risley_dining":                     @"Risley",
      @"robert_purcell_marketplace_eatery": @"RPCC",
      @"rose_house_dining_room":            @"Rose",
      @"104west":                           @"104West!",

      @"amit_bhatia_libe_cafe":             @"Amit Bhatia's Libe Café",
      @"bears_den":                         @"Bear's Den",
      @"carols_cafe":                       @"Carol's Café",
      @"goldies":                           @"Goldie's",
      @"jansens_market":                    @"Jansen's Market",
      @"marthas_cafe":                      @"Martha's Café",
      @"rustys":                            @"Rusty's",
      @"cornell_dairy_bar":                 @"Dairy Bar"};
    
    // Return nickname if applicable
    NSString *nickname = [nicknames objectForKey:name];
    if (nickname) return nickname;
    
    // Else just remove underscores, map cafe -> café, and capitalize first letters
    else return [[[name stringByReplacingOccurrencesOfString:@"_" withString:@" "]
                        stringByReplacingOccurrencesOfString:@"cafe" withString:@"café"]
                        capitalizedString];
}

/** Returns true iff the given dining location is a dining room (as opposed to a café, etc.) */
+ (BOOL)isDiningRoom:(NSString *)name {
    NSSet *const diningRooms = [[NSSet alloc] initWithArray:
  @[@"becker_house_dining_room",
    @"cook_house_dining_room",
    @"jansens_dining_room_bethe_house",
    @"keeton_house_dining_room",
    @"north_star",
    @"okenshields",
    @"risley_dining",
    @"robert_purcell_marketplace_eatery",
    @"rose_house_dining_room",
    @"104west"]];
    
    return [diningRooms containsObject:name];
}

@end
