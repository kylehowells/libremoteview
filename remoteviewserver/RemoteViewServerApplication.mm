#import <AppSupport/CPDistributedMessagingCenter.h>
#import "RootViewController.h"
#import <objc/runtime.h>


@interface UIWindow ()
-(unsigned)_contextId;
@end


@interface RemoteViewServerApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
    CPDistributedMessagingCenter *messagingCenter;
}
@property (nonatomic, retain) UIWindow *window;
@end

@implementation RemoteViewServerApplication
@synthesize window = _window;
-(void)applicationDidFinishLaunching:(UIApplication *)application{
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.layer.borderColor = [UIColor redColor].CGColor;
    _window.layer.borderWidth = 5;
	_viewController = [[RootViewController alloc] init];
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
    
    
    messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.messaging.center"];
    [messagingCenter runServerOnCurrentThread];
    [messagingCenter registerForMessageName:@"contextID" target:self selector:@selector(kh_remoteViewServerMessageNamed:userInfo:)];
}


-(NSDictionary*)kh_remoteViewServerMessageNamed:(NSString*)name userInfo:(id)userInfo{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    unsigned int contextID = [_window _contextId];
    NSNumber *number = [NSNumber numberWithUnsignedInt:contextID];
    [dictionary setObject:number forKey:@"contextID"];
    
    return [dictionary autorelease];
}

-(void)dealloc{
	[_viewController release];
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
