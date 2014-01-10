//
//  CAXAccessibilityPanelController.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 10.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXAccessibilityPanelController.h"

NSString * const kSecurityPreferencePaneName = @"Security.prefPane";

@interface CAXAccessibilityPanelController ()

@end

@implementation CAXAccessibilityPanelController

- (id)initWithWindowNibName:(NSString *)nibNameOrNil
{
    self = [super initWithWindowNibName:nibNameOrNil];
    
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)openSystemPreferences:(id)sender
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
