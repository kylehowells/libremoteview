#import <AppSupport/CPDistributedMessagingCenter.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//#include <substrate.h>

@interface CALayerHost : CALayer
@property (nonatomic, assign) unsigned int contextId;
@end



@interface KHRemoteView : UIView {
    BOOL update;
}
@property (nonatomic, retain) CALayerHost *layerHost;
+(KHRemoteView*)remoteView;
-(void)startUpdating;
-(void)updateDisplay;
-(void)stopUpdating;
@end

static CPDistributedMessagingCenter *messagingCenter = nil;

@implementation KHRemoteView
@synthesize layerHost = _layerHost;

//+(Class)layerClass{
//    Class hostLayerClass = objc_getClass("CALayerHost");
//    return (hostLayerClass ? hostLayerClass : [CALayer class]);
//}

+(KHRemoteView*)remoteView{
    KHRemoteView *remoteView = [[KHRemoteView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    messagingCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.messaging.center"];
    NSDictionary *reply = [messagingCenter sendMessageAndReceiveReplyName:@"contextID" userInfo:nil];
    
    NSNumber *number = [reply objectForKey:@"contextID"];
    remoteView.layerHost.contextId = [number unsignedIntValue];
    
    return remoteView;
}

-(void)startUpdating{
    update = YES;
    [self updateDisplay];
}
-(void)updateDisplay{
    if (update) {
        unsigned int contextID = self.layerHost.contextId;
        self.layerHost.contextId = 0;
        self.layerHost.contextId = contextID;
        [self performSelector:@selector(updateDisplay) withObject:nil afterDelay:(1/60)];
    }
}
-(void)stopUpdating{
    update = NO;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layerHost = [[objc_getClass("CALayerHost") alloc] init];
        self.layerHost.anchorPoint = CGPointMake(0,0);
        self.layerHost.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        self.layerHost.bounds = self.bounds;
        [self.layer addSublayer:self.layerHost];
        update = NO;
    }
    
    return self;
}
-(void)dealloc{
    self.layerHost = nil;
    
    [super dealloc];
}
- (void)didMoveToWindow{
    if (self.window && self.layerHost && self.layerHost.contextId != 0) {
        [self startUpdating];
    }
}

+(void)load{
    [super load];
    
    [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.iky1e.remoteView.sb.messaging.center"] sendMessageAndReceiveReplyName:@"kh_launch_remote_app" userInfo:nil];
}
@end


// vim:ft=objc
