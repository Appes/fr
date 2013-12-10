//
//  DetailViewController.m
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 02.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PrekazkyViewController.h"
#import "DetailCell.h"
#import "fotkyView.h"


@interface DetailViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation DetailViewController {
    NSMutableArray *popis;
    NSMutableArray *lat;
    NSMutableArray *lng;
    NSMutableArray *popis2;
    NSMutableArray *popis3;
    NSMutableArray *popis4;
    
    NSMutableArray *nazev;
    NSMutableArray *state;
    
    NSMutableArray *prekazkaNazev;
    NSMutableArray *prekazkaState;
    NSMutableArray *prekazkaType;
    NSMutableArray *prekazkaPhoto;
    
    NSMutableArray *newsTitle;
    NSMutableArray *newsText;
    NSMutableArray *newsId;
    
    NSMutableArray *newsFotkaId;
    NSMutableArray *newsFotkaURL;
    
    NSMutableArray *fotkyParkCelek;
    
    int coUkazat;
    
    UIActivityIndicatorView *indicator;
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
    
    coUkazat = 0;
    
    prekazkaNazev = [[NSMutableArray alloc] init];
    prekazkaState = [[NSMutableArray alloc] init];
    prekazkaType = [[NSMutableArray alloc] init];
    prekazkaPhoto = [[NSMutableArray alloc] init];
    
    newsText = [[NSMutableArray alloc] init];
    newsTitle = [[NSMutableArray alloc] init];
    newsId = [[NSMutableArray alloc] init];
    
    newsFotkaId = [[NSMutableArray alloc] init];
    newsFotkaURL = [[NSMutableArray alloc] init];
    
    nazev = [[NSMutableArray alloc] init];
    state = [[NSMutableArray alloc] init];
    
    popis = [[NSMutableArray alloc] init];
    popis2 = [[NSMutableArray alloc] init];
    popis3 = [[NSMutableArray alloc] init];
    popis4 = [[NSMutableArray alloc] init];
    lat = [[NSMutableArray alloc] init];
    lng = [[NSMutableArray alloc] init];
    
    fotkyParkCelek = [[NSMutableArray alloc] init];
    
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 12.0;
    NSLog(@"%@", _idPark);
    
    indicator =[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center=self.view.center;
    [self.view addSubview:indicator];
    
    [self stahniData];
}

-(void) stahniData {
    [indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        
        NSString *url = [NSString stringWithFormat:@"http://beta.freeride.cz/parkapi/index.php?park_id=%@", _idPark];
        
        NSData* kivaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSDictionary* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
        }
        
        popis = [NSMutableArray arrayWithArray:[json valueForKey:@"description"]];
        popis2 = [NSMutableArray arrayWithArray:[json valueForKey:@"prices"]];
        popis3 = [NSMutableArray arrayWithArray:[json valueForKey:@"parking"]];
        popis4 = [NSMutableArray arrayWithArray:[json valueForKey:@"entertainment"]];
        lat = [NSMutableArray arrayWithArray:[json valueForKey:@"lat"]];
        lng = [NSMutableArray arrayWithArray:[json valueForKey:@"lon"]];
        
        nazev = [NSMutableArray arrayWithArray:[json valueForKey:@"title"]];
        state = [NSMutableArray arrayWithArray:[json valueForKey:@"state"]];
        
        prekazkaNazev = [NSMutableArray arrayWithArray:[json valueForKey:@"obstacleTitle"]];
        prekazkaPhoto = [NSMutableArray arrayWithArray:[json valueForKey:@"obstaclePhoto"]];
        prekazkaState = [NSMutableArray arrayWithArray:[json valueForKey:@"obstacleState"]];
        prekazkaType = [NSMutableArray arrayWithArray:[json valueForKey:@"obstacleTypeTXT"]];
        
        newsText = [NSMutableArray arrayWithArray:[json valueForKey:@"newsText"]];
        newsTitle = [NSMutableArray arrayWithArray:[json valueForKey:@"newsTitle"]];
        newsId = [NSMutableArray arrayWithArray:[json valueForKey:@"id"]];
        
        fotkyParkCelek = [NSMutableArray arrayWithArray:[json valueForKey:@"simple_park_photo"]];
        
        newsFotkaURL = [NSMutableArray arrayWithArray:[json valueForKey:@"newsImageURL"]];
        newsFotkaId = [NSMutableArray arrayWithArray:[json valueForKey:@"newsID"]];
        
        
        
        for (int i=0; i < prekazkaNazev.count; i++) {
            if (![[prekazkaNazev objectAtIndex:i] isKindOfClass:[NSNull class]]) {
            } else {
                [prekazkaNazev removeObjectIdenticalTo:[prekazkaNazev objectAtIndex:i]];
                [prekazkaPhoto removeObjectIdenticalTo:[prekazkaPhoto objectAtIndex:i]];
                [prekazkaState removeObjectIdenticalTo:[prekazkaState objectAtIndex:i]];
                [prekazkaType removeObjectIdenticalTo:[prekazkaType objectAtIndex:i]];
            }
        }
        
        
        for (int i=0; i < newsTitle.count; i++) {
            if (![[newsTitle objectAtIndex:i] isKindOfClass:[NSNull class]]) {
            } else {
                [newsTitle removeObjectIdenticalTo:[newsTitle objectAtIndex:i]];
                [newsText removeObjectIdenticalTo:[newsText objectAtIndex:i]];
                [newsId removeObjectIdenticalTo:[newsId objectAtIndex:i]];
            }
        }
        
        for (int i=0; i < fotkyParkCelek.count; i++) {
            if (![[fotkyParkCelek objectAtIndex:i] isKindOfClass:[NSNull class]]) {
            } else {
                [fotkyParkCelek removeObjectIdenticalTo:[fotkyParkCelek objectAtIndex:i]];
            }
        }
        
        for (int i=0; i < newsFotkaId.count; i++) {
            if (![[newsFotkaId objectAtIndex:i] isKindOfClass:[NSNull class]]) {
            } else {
                [newsFotkaId removeObjectIdenticalTo:[newsFotkaId objectAtIndex:i]];
                [newsFotkaURL removeObjectIdenticalTo:[newsFotkaURL objectAtIndex:i]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            
            NSLog(@"%@", prekazkaState);
            
            if ([state[0] isEqualToString:@"1"]) {
                //v provozu
                [_parkStateImage setImage:[UIImage imageNamed:@"park_v_provozu.png"]];
            } else {
                 [_parkStateImage setImage:[UIImage imageNamed:@"park_neprovoz.png"]];
            }
            _nadpisPark.text = [NSString stringWithFormat:@"%@", nazev[0]];
            
            [self ukazAktualni];
            [indicator stopAnimating];
        });
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedAktualni:(id)sender {
    [self ukazAktualni];
}

-(void) ukazAktualni {
    [_buttonAktualni setBackgroundImage:[UIImage imageNamed:@"aktualnid_modry.png"] forState:UIControlStateNormal];
    [_buttonNavigovat setBackgroundImage:[UIImage imageNamed:@"navigovat.png"] forState:UIControlStateNormal];
    [_buttonKomentare setBackgroundImage:[UIImage imageNamed:@"komentare.png"] forState:UIControlStateNormal];
    [_buttonPopis setBackgroundImage:[UIImage imageNamed:@"popis.png"] forState:UIControlStateNormal];
    
    coUkazat = 0;
    [_tableView reloadData];
}

- (IBAction)tappedPopis:(id)sender {
    [_buttonAktualni setBackgroundImage:[UIImage imageNamed:@"aktualnid.png"] forState:UIControlStateNormal];
    [_buttonNavigovat setBackgroundImage:[UIImage imageNamed:@"navigovat.png"] forState:UIControlStateNormal];
    [_buttonKomentare setBackgroundImage:[UIImage imageNamed:@"komentare.png"] forState:UIControlStateNormal];
    [_buttonPopis setBackgroundImage:[UIImage imageNamed:@"popis_modry.png"] forState:UIControlStateNormal];
    
    coUkazat = 1;
    [_tableView reloadData];
}

- (IBAction)tappedKomentare:(id)sender {
    [_buttonAktualni setBackgroundImage:[UIImage imageNamed:@"aktualnid.png"] forState:UIControlStateNormal];
    [_buttonNavigovat setBackgroundImage:[UIImage imageNamed:@"navigovat.png"] forState:UIControlStateNormal];
    [_buttonKomentare setBackgroundImage:[UIImage imageNamed:@"komentare_detail.png"] forState:UIControlStateNormal];
    [_buttonPopis setBackgroundImage:[UIImage imageNamed:@"popis.png"] forState:UIControlStateNormal];
    
    coUkazat = 2;
    [_tableView reloadData];
}

- (IBAction)tappedNavigovat:(id)sender {
    [_buttonAktualni setBackgroundImage:[UIImage imageNamed:@"aktualnid.png"] forState:UIControlStateNormal];
    [_buttonNavigovat setBackgroundImage:[UIImage imageNamed:@"navigovat_modry.png"] forState:UIControlStateNormal];
    [_buttonKomentare setBackgroundImage:[UIImage imageNamed:@"komentare.png"] forState:UIControlStateNormal];
    [_buttonPopis setBackgroundImage:[UIImage imageNamed:@"popis.png"] forState:UIControlStateNormal];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    NSString* url = [NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=%f,%f&daddr=%@,%@", [locations[0] coordinate].latitude, [locations[0] coordinate].longitude, lat[0] , lng[0]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"prekazky"])
    {
        PrekazkyViewController *detailViewController = [segue destinationViewController];
        
        // and add any other code which you want to perform.
        
        detailViewController.prekazkyTitle = prekazkaNazev;
        detailViewController.prekazkyState = prekazkaState;
        detailViewController.prekazkyPhoto = prekazkaPhoto;
        detailViewController.prekazkyType = prekazkaType;
        
    }
    
    if ([[segue identifier] isEqualToString:@"pushFotky"])
    {
        fotkyView *detailViewController = [segue destinationViewController];
        
        // and add any other code which you want to perform.
        if (coUkazat == 0) {
            NSString *idNews = [newsId objectAtIndex:[_tableView indexPathForSelectedRow].row];
            NSMutableArray *pomocnePole = [[NSMutableArray alloc] init];
            
            for (int i=0; i < newsFotkaURL.count; i++) {
                if ([newsFotkaId[i] isEqualToString:idNews]) {
                    [pomocnePole addObject:newsFotkaURL[i]];
                }
            }
            
            detailViewController.fotkyURL = pomocnePole;
        }
        
        if (coUkazat == 1) {
            detailViewController.fotkyURL = fotkyParkCelek;
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (coUkazat == 0) {
        //aktualni
        return [newsText count];
    } else if (coUkazat == 1) {
        //popis
        return 1;
    } else {
        //komentare
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"detailCell";
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.27];
    
    // Configure the cell...
    if (coUkazat == 0) {
        //aktualni
        cell.label1.text = [newsText objectAtIndex:newsText.count-1-indexPath.row];
    } else if (coUkazat == 1) {
        //popis
        cell.label1.text = [NSString stringWithFormat:@"%@ %@ %@ %@", popis[0], popis2[0], popis3[0], popis4[0]];
    } else {
        //komentare
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *delkaPopisu = @"";
    
    if (coUkazat == 0) {
        //aktualni
        delkaPopisu = [newsText objectAtIndex:indexPath.row];
    } else if (coUkazat == 1) {
        //popis
        delkaPopisu = [NSString stringWithFormat:@"%@ %@ %@ %@", popis[0], popis2[0], popis3[0], popis4[0]];
    } else {
        //komentare
        delkaPopisu = @"";
    }
    
    return (delkaPopisu.length + 10 < 40) ? 40 : 3*delkaPopisu.length/4;
}

- (IBAction)tappedOblibene:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    NSString *oblibeneString = [prefs objectForKey:@"oblibene"];
    if (oblibeneString == NULL) oblibeneString = @"";
    
    NSArray *poleOblibenych = [oblibeneString componentsSeparatedByString:@","];
    
    
    if ([poleOblibenych indexOfObject:_idPark] == NSNotFound) {
        //jeste to neni v oblibenych, pridej
        if (oblibeneString.length > 1) {
            oblibeneString = [oblibeneString stringByAppendingFormat:@",%@", _idPark];
        } else {
            oblibeneString = @"";
            oblibeneString = [oblibeneString stringByAppendingFormat:@"%@", _idPark];
        }
        
        [prefs setObject:oblibeneString forKey:@"oblibene"];
        [prefs synchronize];
        
        //ukazu ze je ulozeno
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Park was added to your favorites" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        //uz to je v oblibenych
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Park is already in your favorites" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(BOOL)shouldAutorotate {
    return UIInterfaceOrientationMaskPortrait;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
