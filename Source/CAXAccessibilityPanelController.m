//
//  CAXAccessibilityPanelController.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 10.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXAccessibilityPanelController.h"
#import "CAXSystemPreferencesUtil.h"

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
    CAXSystemPreferencesUtil *prefsUtil = [[CAXSystemPreferencesUtil alloc] init];
    
    [prefsUtil openAccessibilitySystemPreferences];
    
    [[self window] orderOut:self];
}

@end
