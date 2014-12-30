//
//  DMDiskStationLoginViewController.m
//  DMDiskStation
//
//  Created by David Muzi on 2014-12-24.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import "DMDiskStationLoginViewController.h"

NSString * const DMAuthURL = @"/webapi/auth.cgi?api=SYNO.API.Auth&version=3&method=login&account=%@&passwd=%@&session=FileStation&format=cookie";


@interface DMDiskStationLoginViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *hostTextField;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;
@property (nonatomic, weak) IBOutlet UISwitch *httpsSwitch;
@property (nonatomic, weak) IBOutlet UIButton *onePasswordButton;
@property (nonatomic, weak) IBOutlet UIView *activityView;

@end

@implementation DMDiskStationLoginViewController

+ (instancetype)loginViewController {
    return [[UIStoryboard storyboardWithName:@"DiskStation" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_hostTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventAllEvents];
    [_hostTextField becomeFirstResponder];
    
    //[_onePasswordButton setHidden:!_onePasswordSupported];
    _onePasswordButton.tintColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    
    NSString *paramURL = [NSString stringWithFormat:DMAuthURL, _usernameTextField.text, _passwordTextField.text];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@:%lu%@", [self protocol], _hostTextField.text, [self portNumber], paramURL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        BOOL authed = NO;
        
        if (error == nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([dict[@"success"] isEqual:@1]) {
                
                NSString *sessionID = dict[@"data"][@"sid"];
                authed = YES;
                
                [_delegate loginViewController:self sessionID:sessionID host:_urlLabel.text];
            }
            
        }
        else {
            [_delegate loginViewController:self sessionID:nil host:nil];
        }
        
    }] resume];
}

- (NSString *)hostName {
    return [[self protocol] stringByAppendingString:_hostTextField.text];
}

- (NSString *)protocol {
    return _httpsSwitch.on ? @"https://" : @"http://";
}

- (NSInteger)portNumber {
    return _httpsSwitch.on ? 5001 : 5000;
}

- (IBAction)textDidChange:(id)sender {
    _urlLabel.text = [NSString stringWithFormat:@"%@:%ld", [self hostName], [self portNumber]];
    
    _onePasswordButton.enabled = _hostTextField.text.length;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _hostTextField) {
        [_usernameTextField becomeFirstResponder];
    }
    else if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else {
        [self savePressed:nil];
    }
    
    return YES;
}

- (IBAction)onePasswordTapped:(id)sender {
    
//    __weak typeof (self) miniMe = self;
//    
//    [[OnePasswordExtension sharedExtension] findLoginForURLString:_hostTextField.text forViewController:self sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
//        if (!loginDict) {
//            if (error.code != AppExtensionErrorCodeCancelledByUser) {
//                NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
//            }
//            return;
//        }
//        
//        __strong typeof(self) strongMe = miniMe;
//        strongMe.usernameTextField.text = loginDict[AppExtensionUsernameKey];
//        strongMe.passwordTextField.text = loginDict[AppExtensionPasswordKey];
//        
//        [self savePressed:nil];
//    }];
}

@end
