//
//  ViewController.h
//  dropboxIntegration
//
//  Created by Rajeev Kumar on 25/03/14.
//  Copyright (c) 2014 rajeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)didPressChoose:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *dropBoxResult;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
