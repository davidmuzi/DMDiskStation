DMDiskStation
=============

An iOS framework to interface with Synology DiskStations

## Purpose

To use a Synology DiskStation NAS as a private cloud in an iOS application.  This framework allows reading and writing to the DiskStation using the FileStation API.


## Installation

Link to the DMDiskStation framework in your application
```obj-c 
#import <DMDiskStation/DMDiskStation.h>
```

## Usage

First an authenticated session must be established with the DiskStation.  A Login view controller can be presented to allow the user to enter their credentials.  No passwords are stored on the device, and the session token is stored securely using the keychain.


```obj-c
    self.session = [[DMDiskStationSession alloc] initWithDelegate:self];
    
    if (_session.isSessionActive == NO) {
        [_session showLoginFromViewController:self.navigationController];
    }
```

Upon a successful authentication, the FileStation API can be used.

```obj-c
- (void)session:(DMDiskStationSession *)session didLogin:(BOOL)success {
    
    if (success) {
    
	    self.api = [[DMFileStationAPI alloc] initWithSession:_session];
	    
	    [self.api fileListForPath:nil callback:^(NSError *error, NSArray *files) {
	        
	        NSLog(@"%@", files);
	        
	    }];

    }
}
```

## Contributions

Are welcome, please submit issues and PRs!
