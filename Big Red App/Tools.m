#import "Tools.h"
@import UIKit;


@implementation UIColor (ExtraColors)
+ (UIColor *)cornellRedColor {
    static UIColor *cornellRed = nil;
    if (!cornellRed) cornellRed = [UIColor colorWithRed:179.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0];
    return cornellRed;
}
@end


@implementation NSDate (ExtraDateFormats)

/** Return a string representing the current date in Cornell red (used for showing latest update time). */
+ (NSAttributedString *)getLatestUpdateString {
    static NSDateFormatter *formatter;
    if (!formatter) formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *latestUpdate = [NSString stringWithFormat:@"Updated %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIColor cornellRedColor] forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:latestUpdate attributes:attributes];
}

@end
