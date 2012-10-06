#import <AppSupport/CPDistributedMessagingCenter.h>
#import "RootViewController.h"
#import <objc/runtime.h>

@interface KHRemoteView : UIView
+(KHRemoteView*)remoteView;
@end


@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor blueColor];
    
    [self performSelector:@selector(startRemoteConnection) withObject:nil afterDelay:5.0];
}

-(void)startRemoteConnection{
    KHRemoteView *view = [objc_getClass("KHRemoteView") remoteView];
    view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_display_remote_app" userInfo:nil];
        self.view.frame = (CGRect){CGPointZero, self.view.bounds.size};
    }];
}
@end
