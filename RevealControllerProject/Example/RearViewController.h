#import <UIKit/UIKit.h>
#import "NDHTMLtoPDF.h"

@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NDHTMLtoPDFDelegate>

// Public Properties:
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

@end