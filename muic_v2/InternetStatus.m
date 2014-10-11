//
//  InternetStatus.m
//  FairPrice
//
//  Created by GOKIRI on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InternetStatus.h"
#import "Reachability.h"


@implementation InternetStatus

-(BOOL)checkWiFiConnection {
    
    Reachability *netReach = [Reachability reachabilityWithHostName:@"www.google.co.th"];
    NetworkStatus netStatus = [netReach currentReachabilityStatus];
    if (netStatus==ReachableViaWiFi) {
        NSLog(@"Reachable (WiFi)!");
        return YES;
    } else if(netStatus==ReachableViaWWAN) {
        NSLog(@"Reachable (WWAN)!");
        return YES;
    } else {
        NSLog(@"Not reachable, aww ");
        return NO;
    }
    return NO;
    
    
}
@end
