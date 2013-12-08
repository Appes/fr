//
//  fotkyView.h
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 05.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fotkyView : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *fotkyURL;

@end
