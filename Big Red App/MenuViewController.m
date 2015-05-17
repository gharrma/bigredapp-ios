#import "MenuViewController.h"

@interface MenuViewController () {
    NSString *diningLocation;
}

@end

@implementation MenuViewController

/** Select a new dining location. */
- (void)setDiningLocation:(NSString *)location {
    diningLocation = location;
}

/** TODO: Display menu. */
- (void)viewDidLoad {
    [super viewDidLoad];
    if (diningLocation) self.detailDescriptionLabel.text = diningLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
