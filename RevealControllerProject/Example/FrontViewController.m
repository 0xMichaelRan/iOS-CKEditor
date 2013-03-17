#import "FrontViewController.h"
#import "RevealController.h"


@interface FrontViewController()
{
    IBOutlet UIWebView *webView;
}

// Private Methods:
- (IBAction)pushExample:(id)sender;
@property (strong, nonatomic) NSString *fileName;
@end

@implementation FrontViewController
@synthesize fileName;


#pragma mark - View lifecycle

/*
 * The following lines are crucial to understanding how the ZUUIRevealController works.
 *
 * In this example, the FrontViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a ZUUIRevealController. Thus the
 * following hierarchy is created:
 *
 * - ZUUIRevealController is parent of:
 * - - UINavigationController is parent of:
 * - - - FrontViewController
 *
 * If you don't want the UINavigationController in between (which is totally fine) all you need to
 * do is to adjust the if-condition below in a way to suit your needs. If the hierarchy were to look 
 * like this:
 *
 * - ZUUIRevealController is parent of:
 * - - FrontViewController
 * 
 * Without a UINavigationController in between, you'd need to change:
 * self.navigationController.parentViewController TO: self.parentViewController
 *
 * Note that self.navigationController is equal to self.parentViewController. Thus you could generalize
 * the code even more by calling self.parentViewController.parentViewController. In order to make 
 * the code easier to understand I decided to go with self.navigationController.
 *
 */
- (id)init
{
    self = [super init];
    self.fileName = @"main.html";
    return self;
}

- (id)initWithFileName:(NSString *)file
{
    self = [super init];
    
    self.fileName = file;
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"CoCKEditor", @"FrontView");
	webView.delegate = self;
    
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
        
        NSString *mainPath =[[[NSBundle mainBundle] bundlePath] stringByAppendingString:[@"/CKEditor/" stringByAppendingString:self.fileName]];
        NSLog(mainPath);
        NSString *basePath =[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/CKEditor/base.html"];
        NSLog(self.fileName);
        
        BOOL fileExistsBase = [[NSFileManager defaultManager]fileExistsAtPath:basePath];
        BOOL fileExistsMain = [[NSFileManager defaultManager]fileExistsAtPath:mainPath];

        
        
        NSString *basecontent = [NSString stringWithContentsOfFile:basePath
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
        
        NSString *javaScriptCodeToReplaceContent = [[@"<script>CKEDITOR.instances.editor1.setData( '" stringByAppendingString:[[RevealController readLocalFile] stringByReplacingOccurrencesOfString:@"\n" withString:@""]] stringByAppendingString:@"');</script>"];
        
        NSString *mainContent = [basecontent stringByAppendingString:javaScriptCodeToReplaceContent];
        NSData *mainContentNSData = [mainContent dataUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(mainContent);
        BOOL a = [mainContentNSData writeToFile:mainPath atomically:YES];
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:mainPath]]];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [RevealController storeToLocalFile:[self getHTMLContent]];
}

- (void)updateLocalFileStorage
{
    [RevealController storeToLocalFile:[self getHTMLContent]];
}

- (NSString *)getHTMLContent
{
    return [webView stringByEvaluatingJavaScriptFromString:
                      @"CKEDITOR.instances.editor1.getData()"];
}

- (void)setHTMLContent: (NSString *)inputFile
{
    [webView stringByEvaluatingJavaScriptFromString:
            @"CKEDITOR.instances.editor1.setData( '<p>try set data.</p>' );"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Example Code

 
@end