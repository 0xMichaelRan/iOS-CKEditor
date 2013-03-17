
#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"

@class FrontViewController;
@class RearViewController;

@interface RevealController : ZUUIRevealController <ZUUIRevealControllerDelegate>

+ (NSString *)readLocalFile;
+ (NSString *)readLocalFileConvertToHTML;
+ (void)storeToLocalFile: (NSString *)saves;


@end