//
//  MDDatePickerViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 7/5/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDatePickerViewController : UIViewController

@property (nonatomic, strong) void(^didSelectDateAction)(NSDate* date);
@property (nonatomic, assign) NSDate* currentDate;

@end
