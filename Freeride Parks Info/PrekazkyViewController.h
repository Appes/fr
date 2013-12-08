//
//  PrekazkyViewController.h
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 02.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrekazkyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *prekazkyTitle;
@property (strong, nonatomic) NSMutableArray *prekazkyType;
@property (strong, nonatomic) NSMutableArray *prekazkyPhoto;
@property (strong, nonatomic) NSMutableArray *prekazkyState;

@end
