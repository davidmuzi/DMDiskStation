//
//  DMDiskStationSession.h
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-24.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DMFileStationAPI;
@class DMDiskStationSession;

@protocol DMDiskStationSessionDelegate <NSObject>

/**
 *  Callback on authentication completion
 *
 *  @param session session object
 *  @param success YES if successfully authenitcated
 */
- (void)session:(DMDiskStationSession *)session didLogin:(BOOL)success;

@end

@interface DMDiskStationSession : NSObject

/**
 *  Default constructor
 *
 *  @param delegate delegate to receive callbacks
 *
 *  @return session object
 */
- (instancetype)initWithDelegate:(id <DMDiskStationSessionDelegate>)delegate;

/**
 *  Is the session authenticated and active
 *
 *  @return YES if authenticated
 */
- (BOOL)isSessionActive;

/**
 *  Presents a view controller to allow the user to authenticate a session with the DiskStation
 *
 *  @param viewController a view controller to present the login view from
 */
- (void)showLoginFromViewController:(UIViewController *)viewController;

/**
 *  Delegate
 */
@property (nonatomic, weak) id <DMDiskStationSessionDelegate> delegate;

/**
 *  The session ID
 */
@property (nonatomic, readonly, strong) NSString *sessionID;

/**
 *  The DiskStation host URL
 */
@property (nonatomic, readonly, copy) NSURL *url;

@end
