//
//  Freeride_Parks_InfoAppDelegate.m
//  Freeride Parks Info
//
//  Created by Yan Renelt on 31.10.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import "Freeride_Parks_InfoAppDelegate.h"

@implementation Freeride_Parks_InfoAppDelegate {
    NSArray *infoNoti;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* deviceTok = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString: @"<" withString: @""]
                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:deviceTok forKey:@"deviceToken"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //posle device token na server, pokud neni pripojeni bude zkouset pri kazdem zapnuti
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults boolForKey:@"poslatToken"] == NO) {
            NSString *url1=@"http://appes.cz/ulozTokenFreeride.php?mujToken=";
            url1 = [url1 stringByAppendingString:deviceTok];
            NSURLRequest *theRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
            NSData *response1 = [NSURLConnection sendSynchronousRequest: theRequest1 returningResponse: nil error: nil];
            NSString * theString1 = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
            
            if ([theString1 isEqualToString:@"ANO"]) {
                [defaults setBool:true forKey:@"poslatToken"];
            }
        }
    });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    if (![[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"Freeride-Parks-Info"]) {
        infoNoti = [[NSArray alloc] init];
        
        //stahnout info o notifikaci
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *url2=@"http://appes.cz/FreerideNotifikace.php";
            NSURLRequest *theRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
            NSData *response2 = [NSURLConnection sendSynchronousRequest: theRequest2 returningResponse: nil error: nil];
            NSString * theString2 = [[NSString alloc] initWithData:response2 encoding:NSUTF8StringEncoding];
            
            infoNoti = [theString2 componentsSeparatedByString:@",x,"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *buttonText;
                
                if ([[NSString alloc] initWithString:[infoNoti objectAtIndex:1]].length == 0) {
                    buttonText = @"OK";
                } else {
                    buttonText = @"Info o akci";
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Freeride parks info" message:[infoNoti objectAtIndex:0] delegate:self cancelButtonTitle:nil otherButtonTitles:buttonText, nil];
                [alert show];
            });
        });
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[infoNoti objectAtIndex:1]]];
    //presmerovani na spravny odkaz
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
    if(self.window.rootViewController){
        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        orientations = [presentedViewController supportedInterfaceOrientations];
    }
    
    return orientations;
}

@end
