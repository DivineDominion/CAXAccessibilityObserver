#import "AppDelegate.h"

@implementation AppDelegate
@synthesize accessibilityObserver;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    __weak id weakSelf = self;
    self.accessibilityObserver = [CAXAccessibilityObserver observerWithGrantedBlock:^{
        NSLog(@"granted");
    } revokedBlock:^{
        NSLog(@"revoked");
        __strong AppDelegate *strongSelf = weakSelf;
        
        // Show request dialogue again
        [strongSelf.accessibilityObserver requestPrivileges];
    }];
    
    [self.accessibilityObserver requestPrivileges];
}

@end
