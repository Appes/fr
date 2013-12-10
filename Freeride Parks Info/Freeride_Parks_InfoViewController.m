//
//  Freeride_Parks_InfoViewController.m
//  Freeride Parks Info
//
//  Created by Yan Renelt on 31.10.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

//vole

#import "Freeride_Parks_InfoViewController.h"
#import "SeznamCell.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"

@interface Freeride_Parks_InfoViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation Freeride_Parks_InfoViewController {
    NSMutableArray *parkId;
    NSMutableArray *parkTitle;
    NSMutableArray *parkNewSnow;
    NSMutableArray *parkSnow;
    NSMutableArray *parkLat;
    NSMutableArray *parkLng;
    NSMutableArray *parkState;
    NSMutableArray *parkLatest;
    
    NSMutableArray *parkDistance;
    
    NSMutableArray *oblibeneId;
    NSMutableArray *oblibeneTitle;
    NSMutableArray *oblibeneNewSnow;
    NSMutableArray *oblibeneSnow;
    NSMutableArray *oblibeneDistance;
    NSMutableArray *oblibeneState;
    
    BOOL oblibene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    oblibene = false;
    
    parkId = [[NSMutableArray alloc] init];
    parkTitle = [[NSMutableArray alloc] init];
    parkNewSnow = [[NSMutableArray alloc] init];
    parkSnow = [[NSMutableArray alloc] init];
    parkLat = [[NSMutableArray alloc] init];
    parkLng = [[NSMutableArray alloc] init];
    parkState = [[NSMutableArray alloc] init];
    parkLatest = [[NSMutableArray alloc] init];
    
    parkDistance = [[NSMutableArray alloc] init];
    
    oblibeneId = [[NSMutableArray alloc] init];
    oblibeneTitle = [[NSMutableArray alloc] init];
    oblibeneNewSnow = [[NSMutableArray alloc] init];
    oblibeneSnow = [[NSMutableArray alloc] init];
    oblibeneDistance = [[NSMutableArray alloc] init];
    oblibeneState = [[NSMutableArray alloc] init];
    
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 12.0;
    
    [self stahniData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) stahniData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        
        NSString *url = [NSString stringWithFormat:@"http://beta.freeride.cz/parkapi/index.php?park_id=all"];
        
        NSData* kivaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSDictionary* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
        }
        
        parkId = [NSMutableArray arrayWithArray:[json valueForKey:@"id"]];
        parkTitle = [NSMutableArray arrayWithArray:[json valueForKey:@"title"]];
        parkNewSnow = [NSMutableArray arrayWithArray:[json valueForKey:@"newSnow"]];
        parkSnow = [NSMutableArray arrayWithArray:[json valueForKey:@"snow"]];
        parkLat = [NSMutableArray arrayWithArray:[json valueForKey:@"lat"]];
        parkLng = [NSMutableArray arrayWithArray:[json valueForKey:@"lon"]];
        parkState = [NSMutableArray arrayWithArray:[json valueForKey:@"state"]];
        parkLatest = [NSMutableArray arrayWithArray:[json valueForKey:@"latestNewsTimestamp"]];
        
        for (int i=0; i < parkId.count; i++) {
            
            [parkDistance addObject:@"-"];
            
            if ([[parkNewSnow objectAtIndex:i] isKindOfClass:[NSNull class]]) [parkNewSnow replaceObjectAtIndex:i withObject:@"0"];
            if ([[parkSnow objectAtIndex:i] isKindOfClass:[NSNull class]]) [parkSnow replaceObjectAtIndex:i withObject:@"0"];
            
            if ([[parkLatest objectAtIndex:i] isKindOfClass:[NSNull class]]) {
                [parkLatest replaceObjectAtIndex:i withObject:@"20100000"];
            } else {
                NSString *pomoc = [[parkLatest objectAtIndex:i] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                pomoc = [pomoc substringToIndex:8];
                [parkLatest replaceObjectAtIndex:i withObject:pomoc];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            
            NSLog(@"%@", parkId);
            [_tableView reloadData];
            [self ukazNejblizsi];
            
        });
        
    });
}

- (IBAction)tappedNejblizsi:(id)sender {
    oblibene = false;
    [self ukazNejblizsi];
}

-(void) ukazNejblizsi {
    [_buttonSnih setImage:[UIImage imageNamed:@"snow_bile.png"] forState:UIControlStateNormal];
    [_buttonAktualni setImage:[UIImage imageNamed:@"aktualni.png"] forState:UIControlStateNormal];
    [_buttonNejblizsi setImage:[UIImage imageNamed:@"nejblizsi_modry.png"] forState:UIControlStateNormal];
    [_buttonOblibene setImage:[UIImage imageNamed:@"oblibene_bile.png"] forState:UIControlStateNormal];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    NSMutableArray *vzdalenosti = [[NSMutableArray alloc] init];
    
    CLLocation *mojePoloha = [[CLLocation alloc] initWithLatitude:[locations[0] coordinate].latitude longitude:[locations[0] coordinate].longitude];
    
    for (int i=0; i < parkLat.count; i++) {
        CLLocation *park = [[CLLocation alloc] initWithLatitude:[[parkLat objectAtIndex:i] doubleValue] longitude:[[parkLng objectAtIndex:i] doubleValue]];
        NSString *stringVzdalenost = [NSString stringWithFormat:@"%f", [park distanceFromLocation:mojePoloha]];
        
        [vzdalenosti addObject:stringVzdalenost];
    }
    
    
    
    //a ted serazeni vzdalenosti a ostatnich poli
    
    float prvni;
    float druhy;
    
    int lim = (int) parkLatest.count;
    do {
        lim--;
        for (int i=0; i< lim; i++) {
            
            prvni = [vzdalenosti[i] floatValue];
            druhy = [vzdalenosti[i+1] floatValue];
            
            //od nejblizsiho
            if (prvni > druhy) {
                [vzdalenosti exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkSnow exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkId exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkTitle exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkNewSnow exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLat exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLng exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLatest exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkState exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
            
        }
    } while (lim > 1);
    
    parkDistance = vzdalenosti;
    
    [_tableView reloadData];
}

- (IBAction)tappedAktualni:(id)sender {
    oblibene = false;
    [_buttonSnih setImage:[UIImage imageNamed:@"snow_bile.png"] forState:UIControlStateNormal];
    [_buttonAktualni setImage:[UIImage imageNamed:@"aktualni_modry.png"] forState:UIControlStateNormal];
    [_buttonNejblizsi setImage:[UIImage imageNamed:@"nejblizsi.png"] forState:UIControlStateNormal];
    [_buttonOblibene setImage:[UIImage imageNamed:@"oblibene_bile.png"] forState:UIControlStateNormal];
    
    float prvni;
    float druhy;
    
    int lim = (int) parkLatest.count;
    do {
        lim--;
        for (int i=0; i< lim; i++) {
            
            prvni = [parkLatest[i] floatValue];
            druhy = [parkLatest[i+1] floatValue];
            
            if (prvni < druhy) {
                [parkSnow exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkId exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkTitle exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkNewSnow exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLat exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLng exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLatest exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkState exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkDistance exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
            
        }
    } while (lim > 1);
    
    
    
    [_tableView reloadData];
}

- (IBAction)tappedSnih:(id)sender {
    oblibene = false;
    [_buttonSnih setImage:[UIImage imageNamed:@"snow_modre.png"] forState:UIControlStateNormal];
    [_buttonAktualni setImage:[UIImage imageNamed:@"aktualni.png"] forState:UIControlStateNormal];
    [_buttonNejblizsi setImage:[UIImage imageNamed:@"nejblizsi.png"] forState:UIControlStateNormal];
    [_buttonOblibene setImage:[UIImage imageNamed:@"oblibene_bile.png"] forState:UIControlStateNormal];
    
    float prvni;
    float druhy;

    int lim = (int) parkSnow.count;
    do {
        lim--;
        for (int i=0; i< lim; i++) {
            
            prvni = [parkSnow[i] floatValue];
            druhy = [parkSnow[i+1] floatValue];
            
            if (prvni < druhy) {
                [parkSnow exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkId exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkTitle exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkNewSnow exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLat exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLng exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkLatest exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkState exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [parkDistance exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
            
        }
    } while (lim > 1);
    
    
    [_tableView reloadData];
}

- (IBAction)tappedOblibene:(id)sender {
    oblibene = true;
    
    [oblibeneTitle removeAllObjects];
    [oblibeneState removeAllObjects];
    [oblibeneSnow removeAllObjects];
    [oblibeneNewSnow removeAllObjects];
    [oblibeneId removeAllObjects];
    [oblibeneDistance removeAllObjects];
    
    [_buttonSnih setImage:[UIImage imageNamed:@"snow_bile.png"] forState:UIControlStateNormal];
    [_buttonAktualni setImage:[UIImage imageNamed:@"aktualni.png"] forState:UIControlStateNormal];
    [_buttonNejblizsi setImage:[UIImage imageNamed:@"nejblizsi.png"] forState:UIControlStateNormal];
    [_buttonOblibene setImage:[UIImage imageNamed:@"oblibene_modre.png"] forState:UIControlStateNormal];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    NSString *oblibeneString = [prefs objectForKey:@"oblibene"];
    if (oblibeneString != NULL) {
        
        NSArray *poleOblibenych = [oblibeneString componentsSeparatedByString:@","];
        
        oblibeneId = [NSMutableArray arrayWithArray:poleOblibenych];
        
        for (int i=0; i < oblibeneId.count; i++) {
            int index = [parkId indexOfObject:[oblibeneId objectAtIndex:i]];
            
            [oblibeneDistance addObject:[parkDistance objectAtIndex:index]];
            [oblibeneNewSnow addObject:[parkNewSnow objectAtIndex:index]];
            [oblibeneSnow addObject:[parkSnow objectAtIndex:index]];
            [oblibeneState addObject:[parkState objectAtIndex:index]];
            [oblibeneTitle addObject:[parkTitle objectAtIndex:index]];
        }
    }

    [_tableView reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (oblibene) {
        return [oblibeneId count];
    } else {
        return [parkId count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"seznamCell";
    
    SeznamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.27];
    
    if (oblibene) {
        cell.labelPark.text = [oblibeneTitle objectAtIndex:indexPath.row];
        cell.labelSnih.text = [NSString stringWithFormat:@"%@cm", [oblibeneSnow objectAtIndex:indexPath.row]];
        cell.labelNewSnih.text = [NSString stringWithFormat:@"+%@cm nový", [oblibeneNewSnow objectAtIndex:indexPath.row]];
        
        if ([[oblibeneState objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            //v provozu
            [cell.stateImage setImage:[UIImage imageNamed:@"park_v_provozu.png"]];
        } else {
            [cell.stateImage setImage:[UIImage imageNamed:@"park_neprovoz.png"]];
        }
        
        NSString *distanceKM = [NSString stringWithFormat:@"%.f km", [[oblibeneDistance objectAtIndex:indexPath.row] floatValue]*1.33/1000];
        
        cell.labelVzdalenost.text = distanceKM;
        
        
    } else {
        cell.labelPark.text = [parkTitle objectAtIndex:indexPath.row];
        cell.labelSnih.text = [NSString stringWithFormat:@"%@cm", [parkSnow objectAtIndex:indexPath.row]];
        cell.labelNewSnih.text = [NSString stringWithFormat:@"+%@cm nový", [parkNewSnow objectAtIndex:indexPath.row]];
        
        if ([[parkState objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            //v provozu
            [cell.stateImage setImage:[UIImage imageNamed:@"park_v_provozu.png"]];
        } else {
            [cell.stateImage setImage:[UIImage imageNamed:@"park_neprovoz.png"]];
        }
        
        cell.labelVzdalenost.text = [NSString stringWithFormat:@"%.f km", [[parkDistance objectAtIndex:indexPath.row] floatValue]*1.33/1000];
    }
    
    
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detail"])
    {
        DetailViewController *detailViewController = [segue destinationViewController];
        
        // and add any other code which you want to perform.
        
        if (oblibene) {
            detailViewController.idPark = [oblibeneId objectAtIndex:[_tableView indexPathForSelectedRow].row];
        } else {
            detailViewController.idPark = [parkId objectAtIndex:[_tableView indexPathForSelectedRow].row];
        }
        
        
        NSLog(@"detail");
        
    }
}
@end
