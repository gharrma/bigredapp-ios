#import "ErrorHandling.h"

#define ALERT_TITLE (@"Hmmm :/")
#define JSON_ERROR_MESSAGE (@"There seems to be an issue with the server--hopefully a temporary one. You may try swiping down to refresh.")
#define NO_MENU_MESSAGE (@"We cannot find a menu for this location.")


@implementation NSError (ExtraErrors)

+ (NSError *)jsonError {
    return [NSError errorWithDomain:@"JSON" code:0 userInfo:@{NSLocalizedDescriptionKey: JSON_ERROR_MESSAGE}];
}

+ (NSError *)noMenuFound {
    return [NSError errorWithDomain:@"Menu" code:0 userInfo:@{NSLocalizedDescriptionKey: NO_MENU_MESSAGE}];
}

@end


@implementation ErrorHandling

+ (void)displayAlertForError:(NSError *)error fromViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
