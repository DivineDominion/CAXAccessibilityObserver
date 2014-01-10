//
//  CAXAccessibilityPanelController.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 10.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXAccessibilityPanelController.h"

NSString * const kSecurityPreferencePaneName = @"Security.prefPane";


@implementation CAXAccessibilityPanelController

- (void)windowDidLoad
{
    // Necessary action to fix 10.7+ gradient bug in textured window
    //   cf. <http://stackoverflow.com/a/11482772/1460929>
    if ([[super window] styleMask] & NSTexturedBackgroundWindowMask)
    {
        [[super window] setContentBorderThickness:0 forEdge:NSMaxYEdge]; // top border
        [[super window] setContentBorderThickness:0 forEdge:NSMinYEdge]; // bottom border
        
        // disable the auto-recalculation of the window's content border
        [[super window] setAutorecalculatesContentBorderThickness:NO forEdge:NSMaxYEdge];
        [[super window] setAutorecalculatesContentBorderThickness:NO forEdge:NSMinYEdge];
    }
}

# pragma mark -

- (IBAction)openSystemPreferences:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[self URLforSecurityPreferencePane]];
    
    [[self window] orderOut:self];
}

- (NSURL *)URLforSecurityPreferencePane {
    NSURL *preferencePaneURL = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *searchPathURLs = [fileManager URLsForDirectory:NSPreferencePanesDirectory inDomains:NSAllDomainsMask];

    for (__strong NSURL *pathURL in searchPathURLs) {
        pathURL = [pathURL URLByAppendingPathComponent:kSecurityPreferencePaneName];
        
        if ([fileManager fileExistsAtPath:[pathURL path] isDirectory:nil])
        {
            preferencePaneURL = pathURL;
            
            break;
        }
    }
    
    NSAssert(preferencePaneURL, @"There was a problem obtaining the path for the specified preference pane: %@", kSecurityPreferencePaneName);
    
    return preferencePaneURL;
}

@end
