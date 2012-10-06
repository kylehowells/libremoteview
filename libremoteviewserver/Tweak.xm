#import <AppSupport/CPDistributedMessagingCenter.h>
#import <QuartzCore/QuartzCore.h>
#import <LibDisplay/LibDisplay.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static CPDistributedMessagingCenter *messagingCenter = nil;


@interface SpringBoard : UIApplication
@end

@interface UIView (Private)
-(BOOL)_isInAWindow;
@end

@interface SBUIController : NSObject
+(SBUIController*)sharedInstance;
-(UIWindow*)window;
@end


@interface SBDisplayStack : NSObject
-(void)pushDisplay:(id)display;
-(void)popDisplay:(id)display;
@end

@interface SBAppContextHostManager : NSObject
-(UIView*)hostViewForRequester:(id)arg1;
-(void)enableHostingForRequester:(NSString*)requesterName orderFront:(BOOL)front;
-(void)disableHostingForRequester:(NSString*)requesterName;
-(UIView*)_realContextHostViewWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear;
@end

@interface SBApplication : NSObject
-(SBAppContextHostManager*)contextHostManager;
@end


@interface SBApplicationController : NSObject
+(SBApplicationController*)sharedInstance;
-(SBApplication*)applicationWithDisplayIdentifier:(NSString*)displayID;
@end

static UIView *contextView = nil;

%hook SpringBoard
-(void)applicationDidFinishLaunching:(UIApplication*)application{
    %orig;
    
    messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"];
    [messagingCenter runServerOnCurrentThread];
    [messagingCenter registerForMessageName:@"kh_launch_remote_app" target:self selector:@selector(kh_remoteViewServerMessageNamed:userInfo:)];
    [messagingCenter registerForMessageName:@"kh_display_remote_app" target:self selector:@selector(kh_remoteViewServerDisplayMessage:userInfo:)];
    [messagingCenter registerForMessageName:@"kh_undisplay_remote_app" target:self selector:@selector(kh_remoteViewServerUndisplayMessage:userInfo:)];
}

%new
-(NSDictionary*)kh_remoteViewServerMessageNamed:(NSString*)name userInfo:(id)userInfo{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    SBDisplayStack *activeStack = [[LibDisplay sharedInstance] SBWActiveDisplayStack];
    
    SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"com.iky1e.remoteviewserver"];
    
    [activeStack pushDisplay:app];
    [activeStack popDisplay:app];
    
    
    NSNumber *number = [NSNumber numberWithBool:YES];
    [dictionary setObject:number forKey:@"success"];
    
    return [dictionary autorelease];
}

%new
-(NSDictionary*)kh_remoteViewServerDisplayMessage:(NSString*)name userInfo:(id)userInfo{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    
    SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"com.iky1e.remoteviewserver"];
    
    SBAppContextHostManager *contextHostManager = [app contextHostManager];
    [contextHostManager enableHostingForRequester:@"TestServer" orderFront:YES];
    contextView = [contextHostManager hostViewForRequester:@"TestServer"];
    contextView.hidden = YES;
    [[[objc_getClass("SBUIController") sharedInstance] window] addSubview:contextView];
    [contextView retain];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"success"];
    return [dictionary autorelease];
}

%new
-(NSDictionary*)kh_remoteViewServerUndisplayMessage:(NSString*)name userInfo:(id)userInfo{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    
    SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"com.iky1e.remoteviewserver"];
    [[app contextHostManager] disableHostingForRequester:@"TestServer"];
    [contextView removeFromSuperview];
    contextView = nil;
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"success"];
    return [dictionary autorelease];
}

%end

