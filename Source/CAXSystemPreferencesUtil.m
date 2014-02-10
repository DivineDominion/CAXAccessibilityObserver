//
//  CAXSystemPreferencesUtil.m
//  WordCounter
//
//  Created by Christian Tietze on 10.02.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXSystemPreferencesUtil.h"

/// For 10.9 Mavericks
NSString * const kSecurityPreferencePaneName = @"Security.prefPane";

/// For pre 10.9
NSString * const kUniversalAccessPreferencePaneName = @"UniversalAccessPref.prefpane";


@implementation CAXSystemPreferencesUtil

- (void)openAccessibilitySystemPreferences
{
    NSURL *systemPreferencePaneURL = nil;
    
    if (AXIsProcessTrustedWithOptions != nil)
    {
        // On Mavericks; use new path
        systemPreferencePaneURL = [self URLforSecurityPreferencePane];
    }
    else
    {
        systemPreferencePaneURL = [self URLforUniversalAccessPreferencePane];
    }
    
    [[NSWorkspace sharedWorkspace] openURL:systemPreferencePaneURL];
}

- (NSURL *)URLforSecurityPreferencePane
{
    return [self URLforPreferencePane:kSecurityPreferencePaneName];
}

- (NSURL *)URLforUniversalAccessPreferencePane
{
    return [self URLforPreferencePane:kUniversalAccessPreferencePaneName];
}

- (NSURL *)URLforPreferencePane:(NSString *)prefPane
{
    NSURL *preferencePaneURL = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *searchPathURLs = [fileManager URLsForDirectory:NSPreferencePanesDirectory inDomains:NSAllDomainsMask];
    
    for (__strong NSURL *pathURL in searchPathURLs) {
        pathURL = [pathURL URLByAppendingPathComponent:prefPane];
        
        if ([fileManager fileExistsAtPath:[pathURL path] isDirectory:nil])
        {
            preferencePaneURL = pathURL;
            
            break;
        }
    }
    
    NSAssert(preferencePaneURL, @"There was a problem obtaining the path for the specified preference pane: %@", prefPane);
    
    return preferencePaneURL;
}

@end
