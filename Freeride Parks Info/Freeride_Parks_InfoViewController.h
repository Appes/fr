//
//  Freeride_Parks_InfoViewController.h
//  Freeride Parks Info
//
//  Created by Yan Renelt on 31.10.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Freeride_Parks_InfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonNejblizsi;
- (IBAction)tappedNejblizsi:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonAktualni;
- (IBAction)tappedAktualni:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonSnih;
- (IBAction)tappedSnih:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOblibene;
- (IBAction)tappedOblibene:(id)sender;

@end
