//
//  BATMyPrescriptionCell.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyPrescriptionCell.h"
#import "UIColor+HNExtensions.h"
#import "NSAttributedString+ParagraphStyle.h"
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]

@interface BATMyPrescriptionCell()

@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UIView *line0;
@property (nonatomic, strong) UIView *line1;


@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation BATMyPrescriptionCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = KHexColor(@"#ebebeb");
        
        
        self.cellView = [UIView new];
        self.cellView.backgroundColor = KHexColor(@"#ffffff");
        [self.contentView addSubview:self.cellView];
        
        self.timeLabel = [TTTAttributedLabel new];
        self.timeLabel.textColor = KHexColor(@"#555555");
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.text = [NSString stringWithFormat:@"2017-10-10      18:18"];
        [self.cellView addSubview:_timeLabel];

       
        
        self.detailLabel = [TTTAttributedLabel new];
        self.detailLabel.textColor = KHexColor(@"#ff8f2b");
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.lineSpacing = 5;
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        [self.cellView addSubview:_detailLabel];
        
        self.line0 = [UIView new];
        self.line0.backgroundColor = KHexColor(@"#e6e6e6");
        [self.cellView addSubview:self.line0];
        
        self.line1 = [UIView new];
        self.line1.backgroundColor = KHexColor(@"#e6e6e6");
        [self.cellView addSubview:self.line1];
        
       
        
        
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter; //标题居中
        self.checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.checkButton.tag = 101;
        [self.checkButton setImage:[UIImage imageNamed:@"icon-ckxq"] forState:UIControlStateNormal];
        [self.checkButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [self.checkButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.checkButton setTitleColor:KHexColor(@"#000000") forState:UIControlStateNormal];
        [self.checkButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellView addSubview:_checkButton];
        
        self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter; //标题居中
        self.buyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.buyButton.tag = 100;
        self.buyButton.enabled = YES;
        [self.buyButton setImage:[UIImage imageNamed:@"icon-gmcfy"] forState:UIControlStateNormal];
        [self.buyButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [self.buyButton setTitle:@"购买处方药" forState:UIControlStateNormal];
        [self.buyButton setTitleColor:KHexColor(@"#000000") forState:UIControlStateNormal];
        [self.buyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellView addSubview:_buyButton];
        
        
        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-11);
        }];
        
        [self.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellView.mas_left).offset(10);
            make.right.equalTo(self.cellView.mas_right).offset(-9);
            make.top.equalTo(self.cellView.mas_top).offset(32);
            make.height.equalTo(@0.5f);
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellView.mas_left).offset(0);
            make.right.equalTo(self.cellView.mas_right).offset(0);
            make.bottom.equalTo(self.cellView.mas_bottom).offset(-32);
            make.height.equalTo(@0.5f);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellView.mas_top).offset(10.0f);
            make.left.equalTo(self.cellView.mas_left).offset(10.0f);
            make.bottom.equalTo(self.line0.mas_top).offset(-7.f);
            make.width.equalTo(self.timeLabel.mas_width);
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellView.mas_top).offset(11.0f);
            make.left.equalTo(self.cellView.mas_left).offset(11.0f);
            make.bottom.equalTo(self.line1.mas_top).offset(-12.f);
            make.right.equalTo(self.cellView.mas_right).offset(-6.0);
        }];
        
        [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cellView.mas_bottom).offset(0);
            make.right.equalTo(self.cellView.mas_right).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@32);
        
        }];
        
        [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cellView.mas_bottom).offset(0);
            make.right.equalTo(self.checkButton.mas_left).offset(-15);
            make.width.equalTo(@100);
            make.height.equalTo(@32);
            
        }];
        
       
        
       

      
    }
    return self;
}

- (void)setDetailString:(NSString *)detailString
{
    [self.detailLabel setText:@"诊断:" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:detailString
                                                                   attributes:@{NSForegroundColorAttributeName : KHexColor(@"#555555"),
                                                                                NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [mutableAttributedString appendAttributedString:string];
        return mutableAttributedString;
    }];
}
+ (CGFloat) heightForCellWithString:(NSString *)string {
    
   
    
    CGFloat bottomSpace = 16;
    
    CGFloat detailHeight = [NSAttributedString contentHeightWithText:string width:SCREEN_WIDTH - 10 - 14 fontSize:12.0f lineSpacing:6.0f];
    
    return detailHeight + bottomSpace;
}

- (void)buttonClick:(UIButton *)button
{
    
   
    if (button.tag == 100) {
        
        if (self.buyButtonBlock) {
            self.buyButtonBlock(self,self.path);

        }
    }
    
    if (button.tag == 101) {
        
        if (self.checkButtonBlock) {
            self.checkButtonBlock(self,self.path);
        }
    }
}

- (void)setModel:(BATOTCConsultListData *)model
{
    if (nil == model) {
        return;
    }
    
    if ([self.OrderNo length] > 0) {
        self.buyButton.enabled = NO;
    }
    else
    {
        self.buyButton.enabled = YES;
    }
    
    self.timeLabel.text = model.RecipeDate;
    self.detailString = model.Diagnosis;
}
@end
