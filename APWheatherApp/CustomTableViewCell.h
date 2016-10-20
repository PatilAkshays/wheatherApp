//
//  CustomTableViewCell.h
//  APWheatherApp
//
//  Created by Mac on 27/07/1938 Saka.
//  Copyright © 1938 Saka Aksh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIStackView *labelDay;

@property (strong, nonatomic) IBOutlet UILabel *labelSky;

@property (strong, nonatomic) IBOutlet UILabel *labelTemprature;

@property (strong, nonatomic) IBOutlet UILabel *labelHumidity;

@property (strong, nonatomic) IBOutlet UILabel *labelMain;







@end
