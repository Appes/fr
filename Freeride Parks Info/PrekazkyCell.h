//
//  PrekazkyCell.h
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 02.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrekazkyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelPrekazka;
@property (weak, nonatomic) IBOutlet UIImageView *pozadiPrekazka;
@property (weak, nonatomic) IBOutlet UILabel *labelFotoPrekazka;

@end
