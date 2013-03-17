#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"
#import "SecondViewController.h"

@interface FrontViewController : UIViewController <UIWebViewDelegate>
{
}

- (void)updateLocalFileStorage;

- (id)initWithFileName:(NSString *)file;

@end