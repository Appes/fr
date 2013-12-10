//
//  fotkyView.m
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 05.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import "fotkyView.h"
#import "fotkaCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface fotkyView ()

@end

@implementation fotkyView {
    UIImageView *myImage;
    UIImageView *share;
    float width;
    float height;
    
    int currentPosition;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"%@", _fotkyURL);
    currentPosition = -2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [_fotkyURL count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    fotkaCell *myCell = [collectionView
                           dequeueReusableCellWithReuseIdentifier:@"fotkaCell"
                           forIndexPath:indexPath];
    
    //UIImage *image;
    //int row = [indexPath row];
    
    // image = [UIImage imageNamed:obrazky[row]];
    //image = [obrazky objectAtIndex:row];
    
    // myCell.jednotlivyObrazek.image = image;
    
    // myCell.jednotlivyObrazek.
    
    [myCell.imageViewFotka setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_fotkyURL objectAtIndex:indexPath.row]]]
                             placeholderImage:[UIImage imageNamed:@"vlocka_info_parky.png"]];
    
    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self nactiObrazek:indexPath.row];
    
}

-(void) nactiObrazek:(int) pozice {
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    currentPosition = pozice;
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (deviceOrientation == UIInterfaceOrientationLandscapeLeft ||
        deviceOrientation == UIInterfaceOrientationLandscapeRight) {
        width = [UIScreen mainScreen].applicationFrame.size.height;
        height = [UIScreen mainScreen].applicationFrame.size.width;
    } else {
        width = [UIScreen mainScreen].applicationFrame.size.width;
        height = [UIScreen mainScreen].applicationFrame.size.height;
    }
    
    myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [myImage setUserInteractionEnabled:true];
    myImage.contentMode = UIViewContentModeScaleAspectFit;
    myImage.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.79];
    
    [myImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_fotkyURL objectAtIndex:pozice]]]
                          placeholderImage:[UIImage imageNamed:@"vlocka_info_parky.png"]];
    
    [self.view addSubview:myImage];
    
    myImage.tag = pozice;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [myImage addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *singleFingerTap2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap2:)];
    [myImage addGestureRecognizer:singleFingerTap2];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer  {
    
    
    [myImage removeFromSuperview];
    [share removeFromSuperview];
    
    currentPosition = -2;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)handleSingleTap2:(UITapGestureRecognizer *)recognizer  {
    
    UIView *tappedView = [recognizer.view hitTest:[recognizer locationInView:recognizer.view] withEvent:nil];
    //beru tag pro rozliseni kliku
    int pozice = tappedView.self.tag;
    
    CGPoint tapPoint = [recognizer locationInView:myImage];
    CGPoint tapPointInView = [myImage convertPoint:tapPoint toView:self.view];
    
    if (tapPointInView.x < width/2 - width/6) {
        if (pozice > 0) {
            [myImage removeFromSuperview];
            [share removeFromSuperview];
            [self nactiObrazek:pozice-1];
        }
    } else if (tapPointInView.x > width/2 + width/6) {
        if (pozice+1 < [_fotkyURL count]) {
            [myImage removeFromSuperview];
            [share removeFromSuperview];
            [self nactiObrazek:pozice+1];
        }
    } else {
        [myImage removeFromSuperview];
        [share removeFromSuperview];
        
        currentPosition = -2;
        
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (currentPosition > -1) {
        [myImage removeFromSuperview];
        [share removeFromSuperview];
        [self nactiObrazek:currentPosition];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
