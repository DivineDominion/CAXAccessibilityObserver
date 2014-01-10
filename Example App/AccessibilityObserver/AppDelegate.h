#import <Cocoa/Cocoa.h>
#import "CAXAccessibilityObserver.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong, readwrite) CAXAccessibilityObserver *accessibilityObserver;

@end
