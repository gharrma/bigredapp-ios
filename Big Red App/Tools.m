#import "Tools.h"
@import UIKit;

static UIColor *CORNELL_RED;


@implementation Tools

+ (void)initialize {
    CORNELL_RED = [UIColor colorWithRed:179.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0];
}

+ (UIColor *)getCornellRed {
    return CORNELL_RED;
}

@end
