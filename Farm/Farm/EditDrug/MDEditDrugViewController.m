//
//  MDEditDrugViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 6/30/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDEditDrugViewController.h"

#define kPickerAnimationDuration 0.40

@interface MDEditDrugViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSManagedObjectContext* childContext;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dosaTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (nonatomic, strong) Drug* object;
@end

@implementation MDEditDrugViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_childContext reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];

    if (self.objectID != nil) {
        self.object = (Drug*)[[self childContext] objectWithID:self.objectID];
    } else {
        self.object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Drug class]) inManagedObjectContext:[self childContext]];
    }
    self.nameTextField.text = self.object.name;
    self.dosaTextField.text = [NSString stringWithFormat:@"%0.1f",[self.object.dose floatValue]];
    self.descriptionTextField.text = self.object.drugDescription;
    
    [self.nameTextField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSManagedObjectContext*)childContext {
    if (_childContext == nil) {
        _childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_childContext setParentContext:self.managedObjectContext];
    }
    return _childContext;
}

- (void)cancelAction {
    [_childContext reset];
    _childContext = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction {
    BOOL isValid = YES;
    NSString* errorMessage = nil;
    NSString* name = self.nameTextField.text;
    float dosa = [self.dosaTextField.text floatValue];
    NSString* description = self.descriptionTextField.text;
    
    if (name == nil || [name isEqualToString:@""]) {
        isValid = NO;
        errorMessage = @"Лекарство по крайней мере должно иметь имя";
    } else {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Drug class])];
        [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@",@keypath(Drug.new, name), name]];
        NSUInteger count = [[self childContext] countForFetchRequest:request error:nil];
        if (count > 0) {
            isValid = NO;
            errorMessage = @"Лекарство с таким именем уже существует";
        }
    }
    
    if (errorMessage) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (isValid) {
        self.object.name = name;
        self.object.dose = @(dosa);
        self.object.drugDescription = description;
        [[self childContext] save:nil];
        [[self managedObjectContext] save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setDosaTextField:nil];
    [self setDescriptionTextField:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.dosaTextField && [self.dosaTextField.text floatValue] == 0) {
        self.dosaTextField.text = nil;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.dosaTextField && [self.dosaTextField.text floatValue] == 0) {
        self.dosaTextField.text = @"0.0";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.dosaTextField becomeFirstResponder];
    }
    if (textField == self.dosaTextField) {
        [self.descriptionTextField becomeFirstResponder];
    }
    if (textField == self.descriptionTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
