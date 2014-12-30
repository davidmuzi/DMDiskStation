//
//  DMDiskStationLoginViewController.h
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-24.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMDiskStationLoginViewController;

@protocol DMDiskStationLoginDelegate <NSObject>

- (void)loginViewController:(DMDiskStationLoginViewController *)viewController sessionID:(NSString *)sessionID host:(NSString *)host;

@end

@interface DMDiskStationLoginViewController : UIViewController

+ (instancetype)loginViewController;

@property (nonatomic, weak) id <DMDiskStationLoginDelegate> delegate;

@end
