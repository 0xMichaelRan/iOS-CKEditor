#import <UIKit/UIKit.h>

// Required for the shadow, cast by the front view.
#import <QuartzCore/QuartzCore.h>

typedef enum
{
	FrontViewPositionLeft,
	FrontViewPositionRight,
	FrontViewPositionRightMost
} FrontViewPosition;

@protocol ZUUIRevealControllerDelegate;

@interface ZUUIRevealController : UIViewController <UITableViewDelegate>

#pragma mark - Public Properties:
@property (strong, nonatomic) IBOutlet UIViewController *frontViewController;
@property (strong, nonatomic) IBOutlet UIViewController *rearViewController;
@property (assign, nonatomic) FrontViewPosition currentFrontViewPosition;
@property (assign, nonatomic) id<ZUUIRevealControllerDelegate> delegate;

// Defines how much of the rear view is shown.
@property (assign, nonatomic) CGFloat rearViewRevealWidth;

// Defines how much of an overdraw can occur when drawing further than 'rearViewRevealWidth'.
@property (assign, nonatomic) CGFloat maxRearViewRevealOverdraw;

// Defines the width of the rear views presentation mode.
@property (assign, nonatomic) CGFloat rearViewPresentationWidth;

// Leftmost point at which a reveal will be triggered if a user stops panning.
@property (assign, nonatomic) CGFloat revealViewTriggerWidth;

// Leftmost point at which a conceal will be triggered if a user stops panning.
@property (assign, nonatomic) CGFloat concealViewTriggerWidth;

// Velocity required for the controller to instantly toggle its state.
@property (assign, nonatomic) CGFloat quickFlickVelocity;

// Default duration for the revealToggle: animation.
@property (assign, nonatomic) NSTimeInterval toggleAnimationDuration;

// Defines the radius of the front view's shadow.
@property (assign, nonatomic) CGFloat frontViewShadowRadius;

#pragma mark - Public Methods:
- (id)initWithFrontViewController:(UIViewController *)aFrontViewController rearViewController:(UIViewController *)aBackViewController;
- (void)revealGesture:(UIPanGestureRecognizer *)recognizer;
- (void)revealToggle:(id)sender;
- (void)revealToggle:(id)sender animationDuration:(NSTimeInterval)animationDuration;

- (void)setFrontViewController:(UIViewController *)frontViewController;
- (void)setFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

- (void)hideFrontView;
- (void)showFrontViewCompletely:(BOOL)completely;

@end

#pragma mark - Delegate Protocol:
@protocol ZUUIRevealControllerDelegate<NSObject>

@optional

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController;
- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController;

/* IMPORTANT: It is not guaranteed that 'didReveal...' will be called after 'willReveal...'! - DO NOT _under any circumstances_ make that assumption!
 */
- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willSwapToFrontViewController:(UIViewController *)frontViewController;
- (void)revealController:(ZUUIRevealController *)revealController didSwapToFrontViewController:(UIViewController *)frontViewController;

#pragma mark New in 0.9.9
- (void)revealController:(ZUUIRevealController *)revealController willResignRearViewControllerPresentationMode:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didResignRearViewControllerPresentationMode:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController;

@end
