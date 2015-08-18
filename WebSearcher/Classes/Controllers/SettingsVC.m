//
//  SettingsVC.m
//  WebSearcher
//
//  Created by  Nechet Oleksandr on 15.08.15.
//  Copyright (c) 2015  Nechet Oleksandr. All rights reserved.
//

#import "SettingsVC.h"
#import "SearchManager.h"

static NSString *const invalidUrl = @"Invalid URL";
static NSString *const emptySerchField = @"Search field must be non empty";

static NSString *const segueToSearchResultVC = @"segueToSearchResultVC";

@interface SettingsVC ()
{
    __weak IBOutlet UILabel *labelErrorMessages;
    __weak IBOutlet UILabel *labelThreads;
    __weak IBOutlet UILabel *labelUrls;
    __weak IBOutlet UITextField *textFieldUrl;
    __weak IBOutlet UITextField *textFieldSearch;
    __weak IBOutlet UIStepper *stepperUrls;
    __weak IBOutlet UIStepper *stepperThreads;
}

@end

@implementation SettingsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [textFieldUrl becomeFirstResponder];
}

#pragma mark - IBActions

- (IBAction)didSearch:(id)sender
{
    NSURL *candidateURL = [NSURL URLWithString:textFieldUrl.text];
    if (!candidateURL || !candidateURL.scheme || !candidateURL.host){
        labelErrorMessages.text = invalidUrl;
        [textFieldUrl becomeFirstResponder];
        return;
    }
    if (textFieldSearch.text.length == 0) {
        labelErrorMessages.text = emptySerchField;
        [textFieldSearch becomeFirstResponder];
        return;
    }
    
    SearchManager *manager = [SearchManager shareManager];
    manager.urlString = textFieldUrl.text;
    manager.searchString = textFieldSearch.text;
    manager.maximumAllowedUrls = (NSUInteger)stepperUrls.value;
    manager.maxConcurrentDownloads = (NSUInteger)stepperThreads.value;
    [manager startSearching];
    
    labelErrorMessages.text = @"";
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:segueToSearchResultVC sender:sender];
}

- (IBAction)didChangeNumberOfScanningUrl:(UIStepper *)sender
{
    labelUrls.text = [NSString stringWithFormat:@"Max allowed scanning url: %.0f", sender.value];
}

- (IBAction)didChangeNumberOfThreads:(UIStepper *)sender
{
    labelThreads.text = [NSString stringWithFormat:@"Max concurrent downloads: %.0f", sender.value];
}

#pragma mark - Helpers



@end
