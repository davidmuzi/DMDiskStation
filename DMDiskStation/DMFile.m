//
//  DMDiskStationFile.m
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-29.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import "DMFile.h"

@implementation DMFile

+ (NSArray *)arrayOfFiles:(NSArray *)json {
    
    NSMutableArray *fileList = [NSMutableArray array];
    
    for (NSDictionary *fileJSON in json) {
        [fileList addObject:[[DMFile alloc] initWithJSON:fileJSON]];
    }
    
    return [NSArray arrayWithArray:fileList];
}


- (instancetype)initWithJSON:(NSDictionary *)json {
    
    if (self = [super init]) {
        _name = json[@"name"];
        _path = json[@"path"];
        _fullPath = json[@"additional"][@"real_path"];
        _isDirectory = [json[@"isdir"] boolValue];
    }
    
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"name: %@\npath: %@", _name, _path];
    
}

@end
