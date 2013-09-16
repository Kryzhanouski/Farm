//
//  MDEditTreatmentViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 7/1/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDEditIllnessViewController.h"

@interface MDEditIllnessViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSManagedObjectContext* childContext;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) Illness* object;
@end

@implementation MDEditIllnessViewController

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
        self.object = (Illness*)[[self childContext] objectWithID:self.objectID];
    } else {
        self.object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Illness class]) inManagedObjectContext:[self childContext]];
    }
    self.nameTextField.text = self.object.name;
    
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
    
    if (name == nil || [name isEqualToString:@""]) {
        isValid = NO;
        errorMessage = @"Болезнь по крайней мере должно иметь имя";
    } else {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Illness class])];
        [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@",@keypath(Illness.new, name), name]];
        NSUInteger count = [[self childContext] countForFetchRequest:request error:nil];
        if (count > 0) {
            isValid = NO;
            errorMessage = @"Болезнь с таким именем уже существует";
        }
    }
    
    if (errorMessage) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (isValid) {
        self.object.name = name;
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
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
