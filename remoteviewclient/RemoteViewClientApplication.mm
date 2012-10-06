#import <AppSupport/CPDistributedMessagingCenter.h>
#import "RootViewController.h"
#import <objc/runtime.h>
#include <dlfcn.h>

@interface RemoteViewClientApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
    BOOL hidden;
}
@property (nonatomic, retain) UIWindow *window;
@end

@implementation RemoteViewClientApplication
@synthesize window = _window;
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    dlopen("/usr/lib/LibRemoteView.dylib", RTLD_NOW);
    
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
    
    hidden = NO;
}
-(void)applicationWillEnterForeground:(UIApplication *)application{
    if (hidden) {
        [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_display_remote_app" userInfo:nil];
    }
}
-(void)applicationDidBecomeActive:(UIApplication *)application{
    if (hidden) {
        [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_display_remote_app" userInfo:nil];
    }
}

-(void)applicationWillResignActive:(UIApplication *)application{
    hidden = YES;
    [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_undisplay_remote_app" userInfo:nil];
}
-(void)applicationDidEnterBackground:(UIApplication *)application{
    hidden = YES;
    [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_undisplay_remote_app" userInfo:nil];
}
-(void)applicationWillTerminate:(UIApplication *)application{
    hidden = YES;
    [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_undisplay_remote_app" userInfo:nil];
}


- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
