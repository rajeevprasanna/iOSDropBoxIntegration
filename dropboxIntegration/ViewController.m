//
//  ViewController.m
//  dropboxIntegration
//
//  Created by Rajeev Kumar on 25/03/14.
//  Copyright (c) 2014 rajeev. All rights reserved.
//

#import "ViewController.h"
#import <DBChooser/DBChooser.h>

@interface ViewController ()
{
        NSUInteger _linkTypeIndex;
        DBChooserResult *_result;
}

@end

@implementation ViewController

@synthesize dropBoxResult;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressChoose:(id)sender {
    NSLog(@"clicked on dropbox button");
    dropBoxResult.text = @"default";
    

    //http://stackoverflow.com/questions/20899250/integrating-dropbox-chooser-in-ios
    //use DBChooserLinkTypeDirectlinks so that we can download file after that
    //follow up this question on stack overflow : http://stackoverflow.com/questions/22657079/preview-of-dropbox-file-in-ios
    

    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypePreview
                                    fromViewController:self completion:^(NSArray *results)
     {
         NSLog(@"went inside");
         if ([results count]) {
             _result = results[0];
             dropBoxResult.text = _result.name;
             NSLog(@"%@", _result.link);
             
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ROFL"
                                                message:@"Dee dee doo doo."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                     [alert show];

             // Process results from Chooser
         } else {
             // User canceled the action
         }
     }];

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [self dbc_cellForOpenerRow:indexPath.row];
}

- (UITableViewCell*)dbc_cellForOpenerRow:(NSInteger)row
{
    UITableViewCell *cell = [self dbc_standardCellWithStyle:UITableViewCellStyleDefault];
    [[cell textLabel] setText:@"Open Chooser"];
    [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
    return cell;
}

- (UITableViewCell*)dbc_standardCellWithStyle:(UITableViewCellStyle)style
{
    NSString *reuseId = [NSString stringWithFormat:@"Cell-%d", style];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseId];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:10]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self didPressChoose1];
        
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didPressChoose1
{
//    DBChooserLinkType linkType = (_linkTypeIndex == DBCLinkTypeRowIndexDirect) ?
//    DBChooserLinkTypeDirect : DBChooserLinkTypePreview;
    NSLog(@"clicked on didPressChoose");
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypePreview fromViewController:self
                                            completion:^(NSArray *results)
     {
             NSLog(@"inside =>   clicked on didPressChoose");
         if ([results count]) {
             _result = results[0];
             
             NSURL *chooserURL = [[self class] dbc_chooserURLForAppKey:@"db-higrms0cmskbm4r" linkType:DBChooserLinkTypePreview];
             
             if ([[UIApplication sharedApplication] canOpenURL:chooserURL]) {
                 [[UIApplication sharedApplication] openURL:chooserURL];
             }
             
             NSLog(@"%@", _result.link);
         } else {
             _result = nil;
             [[[UIAlertView alloc] initWithTitle:@"CANCELLED" message:@"user cancelled!"
                                        delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]
              show];
         }
         [[self tableView] reloadData];
     }];
}

+ (NSURL*)dbc_chooserURLForAppKey:(NSString*)appKey linkType:(DBChooserLinkType)linkType
{
    NSString *kDBCProtocol = @"dbapi-3";
    NSString *kDBCAPIVersion = @"1";
    NSString *baseURL = [NSString stringWithFormat:@"%@://%@/chooser", kDBCProtocol, kDBCAPIVersion];
    NSString *linkTypeString = [[self class] dbc_getLinkTypeString:linkType];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?k=%@&linkType=%@", baseURL, appKey, linkTypeString]];
    NSLog(@"url to be opened => %@", url);

    
    return url;//[NSURL URLWithString:[NSString stringWithFormat:@"%@?k=%@&linkType=%@", baseURL, appKey, linkTypeString]];
}

+ (NSString*)dbc_getLinkTypeString:(DBChooserLinkType)linkType
{
    switch (linkType) {
        case DBChooserLinkTypeDirect:
            return @"direct";
        case DBChooserLinkTypePreview:
            return @"preview";
        default:
            assert(NO); // unknown link type
    }
}
 
@end
