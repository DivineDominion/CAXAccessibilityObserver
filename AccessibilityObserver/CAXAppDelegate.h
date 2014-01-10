//
//  CAXAppDelegate.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CAXAccessibilityObserver.h"

@interface CAXAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong, readwrite) CAXAccessibilityObserver *accessibilityObserver;

@end
