//
//  MDDatePickerViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 7/5/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDDatePickerViewController.h"

@interface MDDatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;

@end

@implementation MDDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.pickerView.date = self.currentDate ? self.currentDate:[NSDate date];
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    self.pickerView.date = self.currentDate ? self.currentDate:[NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    UIPopoverController* popover = [self valueForKey:@"_popoverController"];
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
}

- (IBAction)doneAction:(id)sender {
    if (self.didSelectDateAction) {
        self.didSelectDateAction(self.pickerView.date);
    }
    UIPopoverController* popover = [self valueForKey:@"_popoverController"];
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
}

- (void)viewDidUnload {
    [self setPickerView:nil];
    [super viewDidUnload];
}
@end
