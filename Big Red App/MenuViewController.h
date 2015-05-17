#import <UIKit/UIKit.h>


@interface MenuViewController : UIViewController

- (void)setDiningLocation:(NSString *)location;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
