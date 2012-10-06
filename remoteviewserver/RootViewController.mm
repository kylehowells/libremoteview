#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RootViewController.h"

static BOOL animate = YES;

@interface RootViewController () <MFMailComposeViewControllerDelegate>
-(void)animateColor1;
-(void)animateColor2;
@end


@implementation RootViewController
-(void)dealloc{
    [centerView release];
    centerView = nil;
    
    animate = NO;
    
    [super dealloc];
}

-(void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    autorotate = NO;
    
    // **** Custom stuff
    centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    centerView.center = self.view.center;
    centerView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:centerView];
    
    [self animateColor1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // **** Or iOS 6 copy (email in another process)
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        //        [picker setSubject:@"Hello from Ankit Vyas!"];
        
        // Set up recipients
        //        NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
        //        [picker setToRecipients:toRecipients];
        //        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
        //        [picker setCcRecipients:ccRecipients];
        //        NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
        //        [picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
        //        NSData *myData = [NSData dataWithContentsOfFile:path];
        //        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
        
        
        NSString *emailBody = [NSString stringWithFormat:@" - Server info\nApp: %@; Bundle: %@", [UIApplication sharedApplication], [NSBundle mainBundle]];
        [picker setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:picker animated:NO];
        [picker release];
    }
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
}

-(void)animateColor1{
    if (!animate) { return; }
    id __block weakSelf = self;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        centerView.transform = CGAffineTransformMakeTranslation(0, 60);
    } completion:^(BOOL finished){
        [weakSelf animateColor2];
    }];
}
-(void)animateColor2{
    if (!animate) { return; }
    id __block weakSelf = self;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        centerView.transform = CGAffineTransformMakeTranslation(0, -60);
    } completion:^(BOOL finished){
        [weakSelf animateColor1];
    }];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return autorotate;
}
@end
