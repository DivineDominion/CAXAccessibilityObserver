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
    self.accessibilityObserver = [CAXAccessibilityObserver observerWithGrantedBlock:^{
        NSLog(@"use something that requires accessibilty privileges");
    } revokedBlock:^{
        NSLog(@"stop doing something that requires accessibilty privileges");
    }];
    
    [self.accessibilityObserver requestPrivileges];
}

@end
