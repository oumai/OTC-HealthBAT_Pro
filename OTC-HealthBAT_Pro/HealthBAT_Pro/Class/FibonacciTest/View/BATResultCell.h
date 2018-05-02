//
//  BATResultCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *resultString;
@property (weak, nonatomic) IBOutlet UIView *backvView;

@property (nonatomic,strong) NSString *tags;

@property (nonatomic,strong) NSString *content;

@end
