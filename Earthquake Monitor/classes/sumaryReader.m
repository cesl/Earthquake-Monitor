//
//  sumaryReader.m
//  Earthquake Monitor
//
//  Created by Cesar Saucedo on 22/06/15.
//  Copyright (c) 2015 César Saucedo. All rights reserved.
//

#import "sumaryReader.h"

@implementation sumaryReader


+ (NSDictionary *) getSumaryFeedfrom:(NSString*)url{

    
    NSString * urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData * jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    
    
    NSError * error = nil;
    
    NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error]: nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:results]
                     forKey:@"sumaryFeed"];
    
    
    NSArray * feedData = [results objectForKey:@"features"];
    NSMutableDictionary * details= [NSMutableDictionary dictionary];
    
    for (int i=0; i< feedData.count; i++) {
        NSLog(@"forinini");
        [details setObject:[self getDetailFeedfrom:[[feedData[i][@"properties"] objectForKey:@"detail"] description]] forKey:[[feedData[i][@"properties"] objectForKey:@"detail"] description]];
        
    }
    
    //NSLog(@"details array = %@", details);
    
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:details]
                     forKey:@"detailFeed"];
    
    [userDefaults synchronize];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    
    

    
    NSLog(@"received %@",  results);
    
    return results;
    
}

+ (NSDictionary *) getDetailFeedfrom:(NSString*)url{
    
    
    NSString * urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData * jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError * error = nil;
    
    NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error]: nil;
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    
    NSLog(@"received %@",  results );
    
    return results;
    
}

@end
