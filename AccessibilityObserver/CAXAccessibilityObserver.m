//
//  CAXAccessibilityObserver.m
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXAccessibilityObserver.h"

// If you set this delay to 0.0, the notification will fire but the new trust
// value won't be accessible in my experience.  This is just heuristics and
// open to adjustment.
#define INVOCATION_DELAY 0.5

@interface CAXAccessibilityObserver ()
{
    BOOL _accessibilityTrusted;
}

@property (nonatomic, assign, readwrite, getter = wasAccessibilityTrusted) BOOL accessibilityTrusted;

- (void)observeAccessibilityNotifications;
- (void)accessibiltySettingsDidChange;

@end

@implementation CAXAccessibilityObserver

@synthesize grantedBlock = _grantedBlock;
@synthesize revokedBlock = _revokedBlock;

+ (instancetype)observerWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock
{
    return [[self alloc] initWithGrantedBlock:grantedBlock revokedBlock:revokedBlock];
}

- (instancetype)initWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock
{
    self = [super init];
    
    if (self)
    {
        self.grantedBlock = grantedBlock;
        self.revokedBlock = revokedBlock;
    }
    
    return self;
}

- (void)observeAccessibilityNotifications
{
    __weak CAXAccessibilityObserver *weakSelf = self;
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.apple.accessibility.api" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        __strong CAXAccessibilityObserver *strongSelf = weakSelf;
        
        [strongSelf performSelector:@selector(accessibiltySettingsDidChange) withObject:nil afterDelay:INVOCATION_DELAY];
    }];
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

- (void)requestPrivileges
{
    if (AXIsProcessTrustedWithOptions != NULL)
    {
        // We're on Mavericks
        
        NSDictionary *options = @{ (__bridge id)kAXTrustedCheckOptionPrompt: @YES };
        
        self.accessibilityTrusted = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
        
        if ([self wasAccessibilityTrusted])
        {
            self.grantedBlock();
        }
        else
        {
            NSLog(@"untrusted");
            // TODO display info message
        }
        
        [self observeAccessibilityNotifications];
    }
    else
    {
        // TODO do something for pre 10.9
    }
}

@end
