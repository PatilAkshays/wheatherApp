//
//  ViewController.h
//  APWheatherApp
//
//  Created by Mac on 25/07/1938 Saka.
//  Copyright © 1938 Saka Aksh. All rights reserved.
//

#define kWeatherAPIKey @"6051085a75f178a063bd554db81ac963"
//#define kLatitude 18.633299

//#define kLongitude 73.806929


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomTableViewCell.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *myLocationManager;
    NSString *currentLatitude;
    NSString *currentLongitude;
    NSMutableArray  *dataList;
    NSArray *week;
    
}


@property (strong, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;

@property (strong, nonatomic) IBOutlet UIButton *getCurrentLocation;

- (IBAction)getWheatherAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *labelPlace;

@property (strong, nonatomic) IBOutlet UILabel *labelTimeDate;

@property (strong, nonatomic) IBOutlet UILabel *labelCurrentTemp;
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;




@end

