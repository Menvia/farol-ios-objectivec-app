//
//  MVAddBeaconViewController.m
//  FaroliOSSample
//
//  Created by Juliano Pacheco on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import "MVAddBeaconViewController.h"
#import "MVBeacon.h"

@interface MVAddBeaconViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *uuidTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorIdTextField;

@property (strong, nonatomic) NSRegularExpression *uuidRegex;
@property (assign, nonatomic, getter = isNameFieldValid) BOOL nameFieldValid;
@property (assign, nonatomic, getter = isUUIDFieldValid) BOOL UUIDFieldValid;

@end

@implementation MVAddBeaconViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ADD_BEACON", nil);
    self.saveButton.title = NSLocalizedString(@"SAVE", nil);
    self.cancelButton.title = NSLocalizedString(@"CANCEL", nil);
    self.UUIDFieldValid = YES;
    self.saveButton.enabled = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView.layer.borderWidth = 0;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.navigationController.view addGestureRecognizer:gestureRecognizer];
    
    [self.nameTextField addTarget:self action:@selector(nameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.uuidTextField addTarget:self action:@selector(uuidTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    // abaixo é utilizado uma expressão regular para validar um conjunto de caracteres para representar um UUID
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    self.uuidRegex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];
}

- (void)nameTextFieldChanged:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.nameFieldValid = YES;
    } else {
        self.nameFieldValid = NO;
    }
    
    self.saveButton.enabled = self.isNameFieldValid && self.isUUIDFieldValid;
}

- (void)uuidTextFieldChanged:(UITextField *)textField {
    NSInteger numberOfMatches = [self.uuidRegex numberOfMatchesInString:textField.text
                                                                options:kNilOptions
                                                                  range:NSMakeRange(0, textField.text.length)];
    if (numberOfMatches > 0) {
        self.UUIDFieldValid = YES;
    } else {
        self.UUIDFieldValid = NO;
    }
    
    self.saveButton.enabled = self.isNameFieldValid && self.isUUIDFieldValid;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    if (self.beaconAddedCompletion) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[self.uuidTextField.text uppercaseString]];
        MVBeacon *newBeacon = [[MVBeacon alloc] initWithName:self.nameTextField.text
                                                    uuid:uuid
                                                   major:[self.majorIdTextField.text intValue]
                                                   minor:[self.minorIdTextField.text intValue]];
        self.beaconAddedCompletion(newBeacon);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
