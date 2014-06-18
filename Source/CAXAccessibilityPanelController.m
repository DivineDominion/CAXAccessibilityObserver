//
//  CAXAccessibilityPanelController.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 10.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "CAXAccessibilityPanelController.h"
#import "CAXSystemPreferencesUtil.h"

@implementation CAXAccessibilityPanelController

- (void)windowDidLoad
{
    [[super window] setLevel:NSPopUpMenuWindowLevel];
    
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
