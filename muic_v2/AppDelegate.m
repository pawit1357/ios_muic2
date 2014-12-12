//
//  AppDelegate.m
//  muic_v2
//
//  Created by icsnk on 8/3/14.
//  Copyright (c) 2014 muic. All rights reserved.
//

#import "AppDelegate.h"
#import "Webservice.h"
#import "InternetStatus.h"
#import "MyUtils.h"
#import "AppConfigDao.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance] setBarTintColor:[[MyUtils MyUtils] colorFromHexString:@"#0b162b"]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0], NSFontAttributeName, nil]];
    
    [NSThread sleepForTimeInterval:3.0];
    // Override point for customization after application launch.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    InternetStatus *internet  = [[InternetStatus alloc]init];
    if([internet checkWiFiConnection]){
        
        NSInteger version = [[Webservice Webservice]isUpdateApp];
        if( [[AppConfigDao AppConfigDao] getCurrentVersion] !=version ){
                //Start load data.
                
                [[Webservice Webservice] getMenu];
                [[Webservice Webservice] getBanner];
                [[Webservice Webservice] getContent];
                
                [[Webservice Webservice] GetBook];
                [[Webservice Webservice] GetQuestion];
                
                    //update version
                [[AppConfigDao AppConfigDao] updateVersion:version];

        }else{
             NSLog(@"Your app is lasted versions.");
        }
    }else{
        NSLog(@"Can't Connect to internet.");
    }

    
    
    return YES;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    //Syncronize update data
    
    NSString *tokenid = [NSString stringWithFormat:@"%@",deviceToken];
    
    tokenid = [tokenid stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenid = [tokenid stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenid = [tokenid stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    if( ![[[AppConfigDao AppConfigDao] getUdid] isEqualToString:@"0"] ){
        InternetStatus *internet  = [[InternetStatus alloc]init];
        if([internet checkWiFiConnection]){
            [[Webservice Webservice]registerDevice:tokenid andPhoneType:@"1"];
            [[AppConfigDao AppConfigDao] updateUdid:tokenid];
        }
    }
    
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@" Failed to register for remote notifications:  %@", error);
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
