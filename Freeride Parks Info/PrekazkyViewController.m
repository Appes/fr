//
//  PrekazkyViewController.m
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 02.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import "PrekazkyViewController.h"
#import "PrekazkyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PrekazkyViewController ()

@end

@implementation PrekazkyViewController {
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
    
    NSLog(@"%@", _prekazkyPhoto);
    
    currentPosition = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_prekazkyTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"prekazkyCell";
    
    PrekazkyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.labelPrekazka.text = [_prekazkyTitle objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    
    if ([[_prekazkyState objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        //v provozu
        [cell.pozadiPrekazka setImage:[UIImage imageNamed:@"prekazkaje.png"]];
    } else {
        [cell.pozadiPrekazka setImage:[UIImage imageNamed:@"prekazkaneni.png"]];
    }
    
   // if (![[_prekazkyPhoto objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
        if ([NSString stringWithFormat:@"%@", [_prekazkyPhoto objectAtIndex:indexPath.row]].length > 8) {
            [cell.labelFotoPrekazka setText:[NSString stringWithFormat:@"Foto"]];
        } else {
            [cell.labelFotoPrekazka setText:[NSString stringWithFormat:@""]];
        }
   // }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([NSString stringWithFormat:@"%@", [_prekazkyPhoto objectAtIndex:indexPath.row]].length > 8) {
        currentPosition = indexPath.row;
        [self nactiObrazek:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 45;
}

-(void) nactiObrazek:(int) pozice {
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
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
    
    [myImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.freeride.cz/files/%@", [_prekazkyPhoto objectAtIndex:pozice]]]
            placeholderImage:[UIImage imageNamed:@"vlocka_info_parky.png"]];
    
    [self.view addSubview:myImage];
    
    myImage.tag = pozice;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [myImage addGestureRecognizer:singleFingerTap];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer  {
    
    
    [myImage removeFromSuperview];
    [share removeFromSuperview];
    
    currentPosition = -1;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (currentPosition > -1) {
        [myImage removeFromSuperview];
        [share removeFromSuperview];
        [self nactiObrazek:currentPosition];
    }
}

@end
