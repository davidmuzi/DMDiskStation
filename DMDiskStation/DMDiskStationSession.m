//
//  DMDiskStationSession.m
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-24.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import "DMDiskStationSession.h"
#import "DMDiskStationLoginViewController.h"
#import "DMFileStationAPI.h"
#import "KeychainItemWrapper.h"

@interface DMDiskStationSession () <DMDiskStationLoginDelegate>

@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, strong) DMDiskStationLoginViewController *loginViewController;
@property (nonatomic, strong) NSString *sessionID;

@property (nonatomic, strong) KeychainItemWrapper *keychain;

@property (nonatomic, copy) NSURL *url;

@end

@implementation DMDiskStationSession

- (instancetype)initWithDelegate:(id <DMDiskStationSessionDelegate>)delegate {
    
    if (self = [self init]) {
        
        _delegate = delegate;
        
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DiskStation" accessGroup:nil];

        _sessionID = [_keychain objectForKey:(__bridge id)kSecValueData];
        _url = [NSURL URLWithString:[_keychain objectForKey:(__bridge id)kSecAttrAccount]];
    }
    
    return self;
}

- (BOOL)isSessionActive {
    
    BOOL active = NO;
    
    active = (_sessionID != nil && _sessionID.length >= 1);
    
    return active;
}

- (void)showLoginFromViewController:(UIViewController *)viewController {
    
    NSParameterAssert(viewController);
    
    _presentingViewController = viewController;
    
    self.loginViewController = [DMDiskStationLoginViewController loginViewController];
    self.loginViewController.delegate = self;
    
    [viewController presentViewController:self.loginViewController animated:YES completion:nil];
}

- (DMDiskStationLoginViewController *)loginViewController {
    
    if (_loginViewController == nil) {
        self.loginViewController = [DMDiskStationLoginViewController loginViewController];
    }
    
    return _loginViewController;
}

#pragma mark - LoginViewController delegate

- (void)loginViewController:(DMDiskStationLoginViewController *)viewController sessionID:(NSString *)sessionID host:(NSString *)host {
    
    _url = [NSURL URLWithString:host];
    _sessionID = sessionID;
    
    // Save the token to the keychain
    [_keychain setObject:sessionID forKey:(__bridge id)(kSecValueData)];
    [_keychain setObject:host forKey:(__bridge id)kSecAttrAccount];
    
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [_delegate session:self didLogin:(sessionID && host)];
}

@end
