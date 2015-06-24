//
//  listTableViewController.m
//  Earthquake Monitor
//
//  Created by Cesar Saucedo on 22/06/15.
//  Copyright (c) 2015 César Saucedo. All rights reserved.
//

#import "listTableViewController.h"
#import "sumaryReader.h"
#import "detailViewController.h"
#import "Reachability.h"

@interface listTableViewController (){
    NSArray * feedData;
    NSArray * colors;
}
    
@end

@implementation listTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(loadSumary)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
     colors = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor yellowColor], [UIColor blueColor], [UIColor purpleColor],    [UIColor orangeColor], [UIColor darkGrayColor],  [UIColor blackColor], [UIColor brownColor], [UIColor redColor], [UIColor colorWithRed:185 green:7 blue:7 alpha:1], nil];
    
    [self loadSumary];
    
}
- (IBAction)refreshBtn:(id)sender {
    [self loadSumary];
}

-(void) loadSumary{
    [self.refreshControl beginRefreshing];
    if ([self connected]) {
        NSLog(@"connected");
        
        dispatch_queue_t loaderQ = dispatch_queue_create("load detail", NULL);
        dispatch_async(loaderQ, ^{
            NSDictionary* data = [sumaryReader getSumaryFeedfrom:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.title = [[data objectForKey:@"metadata"] objectForKey:@"title"];
                feedData = [data objectForKey:@"features"];
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
                
            });
        });
        
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sumaryFeed"] != nil ) {
            
            NSLog(@"smaryFeed = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"sumaryFeed"] );
            
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"sumaryFeed"];
            NSDictionary *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //NSDictionary * temp  = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
            
            
            
            
            
            self.title = [[temp objectForKey:@"metadata"] objectForKey:@"title"];
            feedData = [temp objectForKey:@"features"];
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
    }else{
        
        [self.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please check your internet connection."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feedData? feedData.count: 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = [[feedData[indexPath.row][@"properties"] objectForKey:@"mag"] description];
    
    cell.textLabel.textColor = colors[[[feedData[indexPath.row][@"properties"] objectForKey:@"mag"] integerValue]];
    
    cell.detailTextLabel.text = [[feedData[indexPath.row][@"properties"] objectForKey:@"place"] description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    detailViewController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    
    detail.titulo = [[feedData[indexPath.row][@"properties"] objectForKey:@"title"] description];
    detail.detailUrl = [[feedData[indexPath.row][@"properties"] objectForKey:@"detail"] description];
    
    [self.navigationController pushViewController:detail animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma MARK connectivity
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

@end
