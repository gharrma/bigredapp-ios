#import "CafeView.h"
#import "ErrorHandling.h"


@implementation CafeView

- (void)showDetailForLocation:(NSString *)location {
    [super showDetailForLocation:location];
}

- (void)viewDidAppear:(BOOL)animated {
    [ErrorHandling displayAlertForError:[NSError noMenuFound] fromViewController:self];
}

@end
