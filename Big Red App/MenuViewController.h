#import <UIKit/UIKit.h>


@interface MenuViewController : UIViewController

- (void)showMenuForLocation:(NSString *)location;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
