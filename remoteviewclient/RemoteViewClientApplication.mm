#import <AppSupport/CPDistributedMessagingCenter.h>
#import "RootViewController.h"
#import <objc/runtime.h>
#include <dlfcn.h>

@interface RemoteViewClientApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
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
}


- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
