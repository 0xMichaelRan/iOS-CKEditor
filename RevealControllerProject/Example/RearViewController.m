#import "RearViewController.h"
#import <MessageUI/MessageUI.h>

#import "RevealController.h"
#import "FrontViewController.h"

#import "SecondViewController.h"


@interface RearViewController()
@end

@implementation RearViewController
@synthesize rearTableView = _rearTableView;
@synthesize PDFCreator;

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
	if (indexPath.row == 0)
	{
		cell.textLabel.text = @"Input Mode";
	}
	else if (indexPath.row == 1)
	{
		cell.textLabel.text = @"Read Mode";
	}
	else if (indexPath.row == 2)
	{
		cell.textLabel.text = @"Open Local File";
	}
	else if (indexPath.row == 3)
	{
		cell.textLabel.text = @"Customize Editor";
	}
	else if (indexPath.row == 4)
	{
		cell.textLabel.text = @"Generate HTML";
	}
	else if (indexPath.row == 5)
	{
		cell.textLabel.text = @"Generate PDF";
	}
	else if (indexPath.row == 6)
	{
		cell.textLabel.text = @"Enlarge the Menu";
	}
	else if (indexPath.row == 7)
	{
		cell.textLabel.text = @"Shrink Menu";
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
	RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;

	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	if (indexPath.row == 0)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        
		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[FrontViewController class]])
            // if current active view is not FirstViewController
		{
			FrontViewController *frontViewController = [[FrontViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
			[revealController setFrontViewController:navigationController animated:NO];
			
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
	// ... and the second row (=1) corresponds to the "MapViewController".
	else if (indexPath.row == 1)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[SecondViewController class]])
            // if current active view is not SecondViewController
		{
            
            SecondViewController *secondViewController = [[SecondViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            
            /*
			MapViewController *mapViewController = [[MapViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
             */
			[revealController setFrontViewController:navigationController animated:NO];
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
    else if (indexPath.row == 2)
    {
        NSString *defaultPath =[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/CKEditor/localFile.html"];
        
        
        BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:defaultPath];
        NSString *defaultContent = [NSString stringWithContentsOfFile:defaultPath
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
        
        
        FrontViewController *frontViewController = [[FrontViewController alloc]initWithFileName:@"localFile.html"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
        
        

        [RevealController storeToLocalFile:defaultContent];
    }
	else if (indexPath.row == 4)
	{
        // send file as html
        
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[FrontViewController class]])
		{
            // if current view controller is FrontViewController, I need to get control of FrontVieController, get html content
            // save it locally and then generate html out of it.
            // if not doing this, the html content used for html will be the old un-updated one.
            
            FrontViewController *front = ((UINavigationController *)revealController.frontViewController).topViewController;
            [front updateLocalFileStorage];
        }
        //generate HTML and email
        NSString *htmlFileContent = [RevealController readLocalFileConvertToHTML];
        // now I just need to save this string to local html file and pop up the email function
        NSData *data = [htmlFileContent dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        
        [data writeToFile:[@"~/Documents/CoCK_Document.html" stringByExpandingTildeInPath]
               atomically:YES];
        
        // now that html file is created, I would send it via email attachment
        [self sendEmail:@"CoCK_Document.html" withMimeTypeOf:@"text/html"];
	}
    else if (indexPath.row == 5)
    {
        // send file as pdf

        NSString *htmlFileContent = [RevealController readLocalFileConvertToHTML];

        self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:htmlFileContent
                                              pathForPDF:[@"~/Documents/CoCK_Document.pdf" stringByExpandingTildeInPath]
                                                delegate:self
                                                pageSize:kPaperSizeA4
                                                 margins:UIEdgeInsetsMake(10, 5, 10, 5)];
        [self sendEmail:@"CoCK_Document.pdf" withMimeTypeOf:@"application/pdf"];
    }
	else if (indexPath.row == 6)
	{
		[revealController hideFrontView];
	}
	else if (indexPath.row == 7)
	{
		[revealController showFrontViewCompletely:NO];
	}
}

- (void)sendEmail:(NSString *)attachmentLocalName withMimeTypeOf:(NSString *)mimeTypeOfAttachment
{
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"The document that I created using CoCKEditor";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"humphreyran@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:attachmentLocalName];
    BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:filePath];
    if (fileExists)
    {
        NSData *attachmentPDF = [[NSFileManager defaultManager]contentsAtPath:filePath];
        [mc addAttachmentData:attachmentPDF mimeType:mimeTypeOfAttachment fileName:attachmentLocalName];
    }
    else
    {
        NSLog(@"Couldn't find generate.phf in local disk thus attachment fails");
    }
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)viewWillAppear:(BOOL)animated
{
    ;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end