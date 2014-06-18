//
//  CAXSystemPreferencesUtil.m
//  WordCounter
//
//  Created by Christian Tietze on 10.02.14.
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
