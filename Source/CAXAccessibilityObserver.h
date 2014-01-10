//
//  CAXAccessibilityObserver.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAXAccessibilityPanelController.h"

@interface CAXAccessibilityObserver : NSObject
{
    BOOL _useCustomDialogue;
    void (^_grantedBlock)(void);
    void (^_revokedBlock)(void);
}

@property (nonatomic, strong, readwrite) CAXAccessibilityPanelController *accessibilityViewController;
@property (nonatomic, strong, readwrite) NSWindowController *windowController;
@property (nonatomic, assign, readwrite) BOOL useCustomDialogue;

@property (nonatomic, strong, readwrite) void (^grantedBlock)(void);
@property (nonatomic, strong, readwrite) void (^revokedBlock)(void);

+ (instancetype)observerWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock;
- (instancetype)initWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock;

- (void)requestPrivileges;

@end