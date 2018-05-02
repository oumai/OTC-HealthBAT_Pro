//
//  BATSearchFiledCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATSearchFiledCellDelegate<NSObject>

- (void)textfileShouldReturnWithText:(NSString *)content textField:(UITextField *)searchField;

//- (void)textfiledidChangeWithText:(NSString *)content;

@end

@interface BATSearchFiledCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *searchFiled;

@property(nonatomic,weak) id <BATSearchFiledCellDelegate> delegate;

@end
