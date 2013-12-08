//
//  SeznamCell.h
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 01.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeznamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelPark;
@property (weak, nonatomic) IBOutlet UILabel *labelSnih;
@property (weak, nonatomic) IBOutlet UILabel *labelVzdalenost;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UILabel *labelNewSnih;

@end
