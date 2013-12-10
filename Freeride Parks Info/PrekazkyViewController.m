//
//  PrekazkyViewController.m
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 02.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import "PrekazkyViewController.h"
#import "PrekazkyCell.h"

@interface PrekazkyViewController ()

@end

@implementation PrekazkyViewController

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
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 45;
}

-(BOOL)shouldAutorotate {
    return UIInterfaceOrientationMaskPortrait;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
