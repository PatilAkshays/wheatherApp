//
//  ViewController.m
//  APWheatherApp
//
//  Created by Mac on 25/07/1938 Saka.
//  Copyright © 1938 Saka Aksh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getCurrentLocation];
    
    [self startLocating];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getCurrentWeatherDataWithLatitude:(double) latitude
                               longitude:(double) longitude
                                  APIKey:(NSString *)key {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@&units=metric",latitude,longitude,key];
    
  //@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&APPID=%@&units=metric",latitude,longitude,key];
                           
                           
    
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}


-(void)getForcastWeatherDataWithLatitude:(double) latitude
                               longitude:(double) longitude
                                  APIKey:(NSString *)key {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&mode=json&appid=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUIForWeeklyData:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}

-(void)updateUIForWeeklyData:(NSDictionary *)resultTableDictionary {
    

    dataList = [resultTableDictionary valueForKey:@"list"];
    
    
    [self.dataTableView reloadData];

}


-(void)updateUI:(NSDictionary *)resultDictionary {
    
    NSLog(@"%@",resultDictionary);
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"main.temp"]];
    
    NSLog(@"\n\nTEMPERATURE BEFORE : %@",temperature);
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);
    
    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    
    NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    
    
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"name"]];
    
    NSString *country = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"sys.country"]];


    
    self.labelPlace.text = city;
    self.labelTimeDate.text = condition.capitalizedString;
    self.labelCurrentTemp.text = temperature;
    self.labelStatus.text = country;
    
    
}


-(void)startLocating {
    
    myLocationManager = [[CLLocationManager alloc]init];
    
    myLocationManager.delegate = self;
    
    [myLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [myLocationManager requestWhenInUseAuthorization];
    
    [myLocationManager startUpdatingLocation];
    
    
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    currentLatitude= [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    
    currentLongitude= [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  
   
      if (currentLocation != nil) {
        [myLocationManager stopUpdatingLocation];
          
    }
    
    
    
    [self getCurrentWeatherDataWithLatitude:currentLatitude.intValue longitude:currentLongitude.intValue APIKey:kWeatherAPIKey];



}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error.localizedDescription);
    
}



- (IBAction)getWheatherAction:(id)sender {
    
    //[self startLocating];
    
    [self getForcastWeatherDataWithLatitude:currentLatitude.intValue longitude:currentLongitude.intValue APIKey:kWeatherAPIKey];

    //[self getCurrentWeatherDataWithLatitude:currentLatitude.intValue longitude:currentLongitude.intValue APIKey:kWeatherAPIKey];


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataList.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Custom_Cell"];
    
    
    NSDictionary *dailyDictionary = [dataList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",dailyDictionary);
    
    
    
    
    cell.labelTemprature.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"temp.day"]];
    
    cell.labelHumidity.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"humidity"]];
    
    cell.labelMain.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"pressure"]];

    NSArray *weather = [dailyDictionary valueForKey:@"weather"];
    
   // NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary1 = weather.firstObject;

    
  //  NSDictionary *weatherDictionary = weather.lastObject;

   // cell.labelSky.text = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"main"]];

   cell.labelSky.text = [NSString stringWithFormat:@"%@",[weatherDictionary1 valueForKey:@"description"]];
    
    
    
    
    
    return  cell;
}



    

@end
