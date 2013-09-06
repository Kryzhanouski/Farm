//
//  MDSelectGroupViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 7/5/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSelectGroupViewController : UITableViewController

@property (nonatomic, strong) void(^didSelectGroupAction)(NSUInteger groupIndex);
@property (nonatomic, assign) NSUInteger selectedIndex;

@end
