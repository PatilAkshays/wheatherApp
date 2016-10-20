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
    
   // [self getCurrentLocation];
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            NSLog(@"%@",error.localizedDescription);
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
    
    NSString *unix = [NSString stringWithFormat:@"%@",[dataList valueForKey:@"dt"]];
    
    double unixTimeStamp = unix.intValue;
    
    NSTimeInterval _interval  =   unixTimeStamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_interval];
    
    NSDateFormatter *formatterDate= [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterHours= [[NSDateFormatter alloc] init];

    
    [formatterDate setLocale:[NSLocale currentLocale]];
    [formatterHours setLocale:[NSLocale currentLocale]];
    
    
    [formatterDate setDateFormat:@"EEEE dd-MMMM-yyyy"];

    [formatterHours setDateFormat:@"HH:mm a"];
    
    
    NSString *dateString = [formatterDate stringFromDate:date];
    NSString *hoursString = [formatterHours stringFromDate:date];
    
    NSDictionary *currentTemprature = dataList.firstObject;
    
    NSDictionary *dic = dataList.firstObject;
    NSArray *weather = [dic valueForKey:@"weather"];
    
    NSDictionary *weatherDictionary = weather.firstObject;
   
    
    _labelStatus.text = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKeyPath:@"description"]];
    
    _labelTimeDate.text = [NSString stringWithFormat:@"%@",dateString];
    _labelTime.text = [NSString stringWithFormat:@"%@",hoursString];
    
    _labelCurrentTemp.text = [NSString stringWithFormat:@"%@°C",[currentTemprature valueForKeyPath:@"temp.day"]];
    
    _labelPlace.text = [NSString stringWithFormat:@"%@",[resultTableDictionary valueForKeyPath:@"city.name"]];

    
   
    [self.dataTableView reloadData];
    
    

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
    
    
    
   // [self getCurrentWeatherDataWithLatitude:currentLatitude.intValue longitude:currentLongitude.intValue APIKey:kWeatherAPIKey];

    [self getForcastWeatherDataWithLatitude:currentLatitude.intValue longitude:currentLongitude.intValue APIKey:kWeatherAPIKey];


}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error.localizedDescription);
    
}



- (IBAction)getWheatherAction:(id)sender {
    
    [self startLocating];
    


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
    
    NSString *unix = [dailyDictionary valueForKey:@"dt"];
    
    
    NSLog(@"%d",unix.intValue);
    
    
    
    double unixTimeStamp = unix.intValue;
    
    NSTimeInterval _interval  =   unixTimeStamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_interval];
    
    NSDateFormatter *formatterDay= [[NSDateFormatter alloc] init];
    
    [formatterDay setLocale:[NSLocale currentLocale]];
    
    [formatterDay setDateFormat:@"EEEE"];
    
    NSString *dayString = [formatterDay stringFromDate:date];
    
        
    
    cell.labelDay.text = [NSString stringWithFormat:@"%@",dayString];
    
    
    
    cell.labelTemprature.text = [NSString stringWithFormat:@"%@°C",[dailyDictionary valueForKeyPath:@"temp.day"]];
    
    cell.labelHumidity.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"humidity"]];
    
    cell.labelMain.text = [NSString stringWithFormat:@"%@",[dailyDictionary valueForKeyPath:@"pressure"]];

    NSArray *weather = [dailyDictionary valueForKey:@"weather"];
    
    NSDictionary *weatherDictionary = weather.firstObject;

    cell.labelSky.text = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    
    
    
    
    return  cell;
}






@end
