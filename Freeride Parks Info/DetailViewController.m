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
    NSString *popis;
    NSString *lat;
    NSString *lng;
    NSString *popis2;
    NSString *popis3;
    NSString *popis4;
    
    NSString *nazev;
    NSString *state;
    
    NSMutableArray *prekazkaNazev;
    NSMutableArray *prekazkaState;
    NSMutableArray *prekazkaType;
    NSMutableArray *prekazkaPhoto;
    
    NSMutableArray *newsTitle;
    NSMutableArray *newsText;
    NSMutableArray *newsId;
    NSMutableArray *newsModified;
    
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
    newsModified = [[NSMutableArray alloc] init];
    
    newsFotkaId = [[NSMutableArray alloc] init];
    newsFotkaURL = [[NSMutableArray alloc] init];
    
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
        
        NSMutableArray* json = [[NSMutableArray alloc] init];
        if (kivaData) {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
        }
        
        popis = json[0][@"description"];
        popis2 = json[0][@"prices"];
        popis3 = json[0][@"parking"];
        popis4 = json[0][@"entertainment"];
        lat = json[0][@"lat"];
        lng = json[0][@"lon"];
        
        nazev = json[0][@"title"];
        state = json[0][@"state"];
        
        for (int i=1; i < json.count; i++) {
            if (json[i][@"obstacleTitle"] != NULL) {
                //jsem v prekazkach
                [prekazkaNazev addObject:json[i][@"obstacleTitle"]];
                [prekazkaPhoto addObject:json[i][@"obstacklePhoto"]];
                [prekazkaState addObject:json[i][@"obstacleState"]];
                [prekazkaType addObject:json[i][@"obstacleTypeTXT"]];
            }
            
            if (json[i][@"newsText"] != NULL) {
                //jsem v news
                [newsText addObject:json[i][@"newsText"]];
                [newsTitle addObject:json[i][@"newsTitle"]];
                [newsId addObject:json[i][@"id"]];
                [newsModified addObject:json[i][@"newsModified"]];
            }
            
            if (json[i][@"simple_park_photo"] != NULL) {
                [fotkyParkCelek addObject:json[i][@"simple_park_photo"]];
            }
            
            if (json[i][@"newsImageURL"] != NULL) {
                [newsFotkaURL addObject:json[i][@"newsImageURL"]];
                [newsFotkaId addObject:json[i][@"newsID"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            
            if ([state isEqualToString:@"1"]) {
                //v provozu
                [_parkStateImage setImage:[UIImage imageNamed:@"park_v_provozu.png"]];
            } else {
                 [_parkStateImage setImage:[UIImage imageNamed:@"park_neprovoz.png"]];
            }
            _nadpisPark.text = [NSString stringWithFormat:@"%@", nazev];
            
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
    
    NSString* url = [NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=%f,%f&daddr=%@,%@", [locations[0] coordinate].latitude, [locations[0] coordinate].longitude, lat , lng];
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
        cell.label1.text = [NSString stringWithFormat:@"%@\n%@", [newsModified objectAtIndex:newsModified.count-1-indexPath.row], [newsText objectAtIndex:newsText.count-1-indexPath.row]];
    } else if (coUkazat == 1) {
        //popis
        cell.label1.text = [NSString stringWithFormat:@"%@ %@ %@ %@", popis, popis2, popis3, popis4];
    } else {
        //komentare
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *delkaPopisu = @"";
    
    if (coUkazat == 0) {
        //aktualni
        delkaPopisu = [NSString stringWithFormat:@"%@\n%@", [newsModified objectAtIndex:indexPath.row], [newsText objectAtIndex:indexPath.row]];
    } else if (coUkazat == 1) {
        //popis
        delkaPopisu = [NSString stringWithFormat:@"%@ %@ %@ %@", popis, popis2, popis3, popis4];
    } else {
        //komentare
        delkaPopisu = @"";
    }
    
    // Get the text so we can measure it
    NSString *text = delkaPopisu;
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(245 - (0 * 2), 20000.0f);
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = MAX(size.height, 44.0f);
    // return the height, with a bit of extra padding in
    return height + (0 * 2);
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
