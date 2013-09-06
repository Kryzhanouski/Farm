//
//  MDTreatmentListViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 6/30/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDIllnessListViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// Actions
@property (nonatomic, strong) void(^didSelectIllAction)(NSManagedObject* ill);
@end
