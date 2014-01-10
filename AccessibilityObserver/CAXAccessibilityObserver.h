//
//  CAXAccessibilityObserver.h
//  AccessibilityObserver
//
//  Created by Christian Tietze on 09.01.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAXAccessibilityObserver : NSObject
{
    void (^_grantedBlock)(void);
    void (^_revokedBlock)(void);
}

@property (nonatomic, strong, readwrite) NSViewController *accessibilityViewController;
@property (nonatomic, strong, readwrite) NSWindowController *windowController;

@property (nonatomic, strong, readwrite) void (^grantedBlock)(void);
@property (nonatomic, strong, readwrite) void (^revokedBlock)(void);

+ (instancetype)observerWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock;
- (instancetype)initWithGrantedBlock:(void (^)(void))grantedBlock revokedBlock:(void (^)(void))revokedBlock;

- (void)requestPrivileges;

@end
