#import "Tools.h"
@import UIKit;


static UIColor *cornellRed, *cornellTan, *cornellGray;

@implementation UIColor (ExtraColors)

+ (UIColor *)cornellRedColor {
    if (!cornellRed) cornellRed = [UIColor colorWithRed:179.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0];
    return cornellRed;
}
+ (UIColor *)cornellTanColor {
    if (!cornellTan) cornellTan = [UIColor colorWithRed:216.0/255.0 green:210.0/255.0 blue:201.0/255.0 alpha:1.0];
    return cornellTan;
}
+ (UIColor *)cornellGrayColor {
    if (!cornellGray) cornellGray = [UIColor colorWithWhite:34.0/255.0 alpha:1.0];
    return cornellGray;
}

@end


@implementation NSDate (ExtraDateFormats)

/** Return a string representing the current date in Cornell red (used for showing latest update time). */
+ (NSAttributedString *)getLatestUpdateString {
    static NSDateFormatter *formatter;
    if (!formatter) formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *latestUpdate = [NSString stringWithFormat:@"Updated %@", [formatter stringFromDate:[NSDate date]]];
    return [[NSAttributedString alloc] initWithString:latestUpdate];
}

@end
