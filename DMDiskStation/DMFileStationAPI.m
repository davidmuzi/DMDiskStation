//
//  DMFileStationAPI.m
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-24.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import "DMFileStationAPI.h"
#import "DMDiskStationSession.h"
#import "DMFile.h"

NSString * const DMFileListURL = @"/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=%@&additional=real_path";
NSString * const DMFilesListURL = @"/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list&_sid=%@&folder_path=%@&additional=real_path";
NSString * const DMFileDownloadURL = @"/webapi/FileStation/file_download.cgi?api=SYNO.FileStation.Download&version=1&method=download&path=%@&_sid=%@&mode=open";
NSString * const DMCreateFolderURL = @"/webapi/FileStation/file_crtfdr.cgi?api=SYNO.FileStation.CreateFolder&version=1&method=create&folder_path=%@&name=%@&_sid=%@";
NSString * const DMUploadFileURL = @"/webapi/FileStation/api_upload.cgi";

@interface DMFileStationAPI () <NSURLSessionDelegate>

@property (nonatomic, copy) DMDiskStationSession *diskSession;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation DMFileStationAPI


- (instancetype)initWithSession:(DMDiskStationSession *)session {
    
    NSParameterAssert(session);
    NSAssert(session.isSessionActive, @"Session must be authenticated");
    
    if (self = [super init]) {
        _diskSession = session;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return self;
}

- (void)fileListForPath:(NSString *)path callback:(void (^)(NSError *error, NSArray /* Files */ *files))callback {
    
    NSURL *url = nil;
    NSString *fileKey = nil;
    
    if (path) {
        NSString *pathURL = [NSString stringWithFormat:DMFilesListURL, _diskSession.sessionID, path];
        url = [NSURL URLWithString:[_diskSession.url.absoluteString stringByAppendingString:pathURL]];
        fileKey = @"files";
    }
    else {
        NSString *pathURL = [NSString stringWithFormat:DMFileListURL, _diskSession.sessionID];
        url = [NSURL URLWithString:[_diskSession.url.absoluteString stringByAppendingString:pathURL]];
        fileKey = @"shares";
    }
    
    [[_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSArray *files = nil;
        
        if (error == nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([dict[@"success"] isEqual:@1]) {
                
                files = [DMFile arrayOfFiles:dict[@"data"][fileKey]];
            }
        }
        else {
            NSLog(@"Error retrieving file list: %@", error.localizedDescription);
        }
        
        callback(error, files);
        
    }] resume];

    
}

- (void)downloadFile:(DMFile *)file callback:(void (^)(NSError *error, DMFile *file))callback {
    
}

- (void)createFolder:(NSString *)folderName atPath:(NSString *)path callback:(void (^)(NSError *error, BOOL success))callback {
    
}

- (void)uploadFile:(NSURL *)filePath toPath:(NSString *)path callback:(void (^)(NSError *error, BOOL success))callback {
    
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    NSString *authMethod = protectionSpace.authenticationMethod;
    
    if ([authMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:protectionSpace.serverTrust]);
    }
}

@end
