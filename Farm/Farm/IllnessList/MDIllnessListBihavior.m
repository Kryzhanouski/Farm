//
//  MDIllnessListBihavior.m
//  Farm
//
//  Created by Mark Kryzhanouski on 7/8/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDIllnessListBihavior.h"
#import "MDEditIllnessViewController.h"
#import "MDIllnessListViewController.h"

@implementation MDIllnessListBihavior

- (MDIllnessListViewController*)illnessController {
    return (MDIllnessListViewController*)_viewController;
}

- (void)setAttachedViewController:(UIViewController *)attachedViewController {
    [super setAttachedViewController:attachedViewController];
    attachedViewController.title = @"Список Болезней";
    attachedViewController.navigationItem.rightBarButtonItems = @[attachedViewController.editButtonItem,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTreatmentAction)]];
    MDIllnessListBihavior* __weak weakSelf = self;
    [[self illnessController] setDidSelectIllAction:^(NSManagedObject * ill) {
        [weakSelf editTreatment:ill];
    }];
}

- (void)addTreatmentAction {
    [self editTreatment:nil];
}

- (void)editTreatment:(NSManagedObject*)object {
    MDEditIllnessViewController* ctr = [[self illnessController].storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDEditIllnessViewController class])];
    [ctr setManagedObjectContext:[self illnessController].managedObjectContext];
    [ctr setObjectID:[object objectID]];
    [[self illnessController].navigationController pushViewController:ctr animated:YES];
}

@end
