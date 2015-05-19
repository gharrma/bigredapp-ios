#import "Tools.h"
@import UIKit;

@implementation UIColor (ExtraColors)
+ (UIColor *)cornellRedColor {
    static UIColor *cornellRed = nil;
    if (!cornellRed) cornellRed = [UIColor colorWithRed:179.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0];
    return cornellRed;
}
@end
