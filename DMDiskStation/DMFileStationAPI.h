//
//  DMFileStationAPI.h
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-24.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMDiskStationSession;
@class DMFile;

@interface DMFileStationAPI : NSObject

- (instancetype)initWithSession:(DMDiskStationSession *)session;

- (void)fileListForPath:(NSString *)path callback:(void (^)(NSError *error, NSArray /* DMFile */ *files))callback;

- (void)downloadFile:(DMFile *)file callback:(void (^)(NSError *error, DMFile *file))callback;

- (void)createFolder:(NSString *)folderName atPath:(NSString *)path callback:(void (^)(NSError *error, BOOL success))callback;

- (void)uploadFile:(NSURL *)filePath toPath:(NSString *)path callback:(void (^)(NSError *error, BOOL success))callback;

@end
