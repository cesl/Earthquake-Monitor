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
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    
    NSLog(@"received %@",  results);
    
    return results;
    
}



@end
