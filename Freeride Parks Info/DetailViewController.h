//
//  DetailViewController.h
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 02.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *idPark;

@property (weak, nonatomic) IBOutlet UIButton *buttonAktualni;
- (IBAction)tappedAktualni:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonPopis;
- (IBAction)tappedPopis:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonKomentare;
- (IBAction)tappedKomentare:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonNavigovat;
- (IBAction)tappedNavigovat:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *parkStateImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonOblibene;
- (IBAction)tappedOblibene:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nadpisPark;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
