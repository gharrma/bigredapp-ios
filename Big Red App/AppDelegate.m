#import "AppDelegate.h"
#import "DiningView.h"
#import "JSONRequests.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [JSONRequests clearCache];
}

@end
