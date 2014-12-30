//
//  DetailViewController.h
//  TestApp
//
//  Created by David Muzi on 2014-12-29.
//  Copyright (c) 2014 muzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

