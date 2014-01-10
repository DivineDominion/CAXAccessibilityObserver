//
//  CAXAccessibilityObserver.m
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXAccessibilityObserver.h"
#import "CAXAccessibilityPanelController.h"

// If you set this delay to 0.0, the notification will fire but the new trust
// value won't be accessible in my experience.  This is just heuristics and
// open to adjustment.
#define INVOCATION_DELAY 0.5

NSString * const kDistributedAccessibilityChangeNotification = @"com.apple.accessibility.api";

@interface CAXAccessibilityObserver ()
{
    BOOL _accessibilityTrusted;
    id _accessibilityChangeObserver;
}

@property (nonatomic, assign, readwrite, getter = wasAccessibilityTrusted) BOOL accessibilityTrusted;
@property (nonatomic, strong, readwrite) id accessibilityChangeObserver;

- (void)observeAccessibilityNotifications;
- (void)accessibiltySettingsDidChange;

@end

@implementation CAXAccessibilityObserver

@synthesize useCustomDialog = _useCustomDialog;
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
    if (AXIsProcessTrustedWithOptions != NULL)
    {
        // We're on Mavericks
        self.accessibilityTrusted = AXIsProcessTrustedWithOptions(NULL);
        
        if ([self wasAccessibilityTrusted])
        {
            self.grantedBlock();
        }
        else
        {
            if ([self useCustomDialog])
            {
                [[self.windowController window] makeKeyAndOrderFront:NSApp];
            }
            else
            {
                NSDictionary *options = @{ (__bridge id)kAXTrustedCheckOptionPrompt: @YES };
                AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
            }
        }
        
        [self observeAccessibilityNotifications];
    }
    else
    {
        // TODO do something for pre 10.9
    }
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
