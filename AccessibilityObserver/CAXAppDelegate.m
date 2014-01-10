//
//  CAXAppDelegate.m
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import "CAXAppDelegate.h"

@implementation CAXAppDelegate
@synthesize accessibilityObserver;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    __weak id weakSelf = self;
    self.accessibilityObserver = [CAXAccessibilityObserver observerWithGrantedBlock:^{
        NSLog(@"granted");
    } revokedBlock:^{
        NSLog(@"revoked");
        __strong CAXAppDelegate *strongSelf = weakSelf;
        
        // Show request dialogue again
        [strongSelf.accessibilityObserver requestPrivileges];
    }];
    
    [self.accessibilityObserver requestPrivileges];
}

@end
