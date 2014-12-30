//
//  DMDiskStationFile.h
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-29.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMFile : NSObject

+ (NSArray *)arrayOfFiles:(NSArray *)json;

- (instancetype)initWithJSON:(NSDictionary *)json;

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSString *path;

@property (nonatomic, strong, readonly) NSString *fullPath;

@property (nonatomic, strong, readonly) NSString *extension;

@property (nonatomic, readonly) BOOL isDirectory;

@property (nonatomic, strong) NSData *data;

@end
