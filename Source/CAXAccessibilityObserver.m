//
//  CAXAccessibilityObserver.m
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
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

#import "CAXAccessibilityObserver.h"
#import "CAXAccessibilityPanelController.h"
#import "CAXSystemPreferencesUtil.h"

// If you set this delay to 0.0, the notification will fire but the new trust
// value won't be accessible in my experience.  This is just heuristics and
// open to adjustment.
#define INVOCATION_DELAY 0.5

NSString * const kDistributedAccessibilityChangeNotification = @"com.apple.accessibility.api";

@interface CAXAccessibilityObserver ()
@property (nonatomic, assign, readwrite, getter = wasAccessibilityTrusted) BOOL accessibilityTrusted;
@property (nonatomic, strong, readwrite) id accessibilityChangeObserver;

- (void)observeAccessibilityNotifications;
- (void)accessibiltySettingsDidChange;
@end

@implementation CAXAccessibilityObserver

+ (instancetype)observerWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock
{
    return [[self alloc] initWithGrantedBlock:grantedBlock revokedBlock:revokedBlock];
}

- (instancetype)initWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock
{
    self = [super init];
    
    if (self)
    {
        self.useCustomDialog = YES;
        
        self.grantedBlock = grantedBlock;
        self.revokedBlock = revokedBlock;
        
        CAXAccessibilityPanelController *viewController = [[CAXAccessibilityPanelController alloc] initWithWindowNibName:@"AccessibilityInfoWindow"];
        
        self.windowController = viewController;
    }
    
    return self;
}

- (void)requestPrivileges
{
    self.accessibilityTrusted = AXIsProcessTrustedWithOptions(NULL);

    if ([self wasAccessibilityTrusted])
    {
        self.grantedBlock();
    }
    else
    {
        // TODO extract to Command
        if ([self useCustomDialog])
        {
            [[self.windowController window] makeKeyAndOrderFront:NSApp];
            [NSApp activateIgnoringOtherApps:YES];
        }
        else
        {
            NSDictionary *options = @{ (__bridge id)kAXTrustedCheckOptionPrompt: @YES };
            AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
        }
    }

    [self observeAccessibilityNotifications];
}

- (void)observeAccessibilityNotifications
{
    if (self.accessibilityChangeObserver == nil)
    {
        __weak CAXAccessibilityObserver *weakSelf = self;
        self.accessibilityChangeObserver = [[NSDistributedNotificationCenter defaultCenter]
                                            addObserverForName:kDistributedAccessibilityChangeNotification
                                            object:nil
                                            queue:[NSOperationQueue mainQueue]
                                            usingBlock:^(NSNotification *note) {
            __strong CAXAccessibilityObserver *strongSelf = weakSelf;
            
            [strongSelf performSelector:@selector(accessibiltySettingsDidChange) withObject:nil afterDelay:INVOCATION_DELAY];
        }];
    }
}

- (void)accessibiltySettingsDidChange
{
    BOOL trustingBefore = [self wasAccessibilityTrusted];
    BOOL trustingNow = AXIsProcessTrustedWithOptions(NULL);
    
    BOOL settingDidChange = (trustingBefore != trustingNow);
    
    if (settingDidChange)
    {
        if (trustingNow)
        {
            self.grantedBlock();
        }
        else
        {
            self.revokedBlock();
        }
        
        self.accessibilityTrusted = trustingNow;
    }
}



@end
