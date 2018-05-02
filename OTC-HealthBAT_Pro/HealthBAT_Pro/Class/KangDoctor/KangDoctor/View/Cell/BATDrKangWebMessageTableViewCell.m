//
//  BATKangDoctorMessageTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangWebMessageTableViewCell.h"

@implementation BATDrKangWebMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        WEAK_SELF(self);

        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@5);
            make.height.lessThanOrEqualTo(@12);
        }];

        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@20);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];

        [self.contentView addSubview:self.bubbleImageView];
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.leading.equalTo(self.avatarImageView.mas_trailing).offset(5);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        }];

//        [self.bubbleImageView addSubview:self.textView];
//        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@0);
//            make.leading.equalTo(@10);
//        }];

        [self.bubbleImageView addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.leading.equalTo(@10);
        }];

    }
    return self;
}

- (void)setMessageModel:(BATDrKangMessageModel *)messageModel {

    if (messageModel.isTimeVisible) {
        NSString *first = [Tools getDateStringWithDate:messageModel.time Format:@"MM-dd"];
        NSString *middle = [Tools getWeekdayStringFromDate:messageModel.time];
        NSString *end = [Tools getDateStringWithDate:messageModel.time Format:@"HH:mm"];
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@%@",first,middle,end];
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
        }];
    }
    else {
        self.timeLabel.text = @"";
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }

    [self.bubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(messageModel.textWidth+10, messageModel.textHeight+10));
    }];

//    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(messageModel.textWidth, messageModel.textHeight));
//    }];
//
//    self.textView.attributedText = messageModel.htmlAttributedStr;

    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(messageModel.textWidth, messageModel.textHeight));
    }];

    [self.webView loadHTMLString:messageModel.content baseURL:nil];
}

#pragma mark - getter
- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.layer.cornerRadius = 45/2.0;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"icon-kbs"];
    }
    return _avatarImageView;
}

- (UIImageView *)bubbleImageView {

    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleImageView.image = [[UIImage imageNamed:@"康博士白色对话"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        _bubbleImageView.userInteractionEnabled = YES;
    }
    return _bubbleImageView;
}

- (UIWebView *)webView {

    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {

        return YES;
    }

    NSURL *URL = request.URL;
    DDLogDebug(@"%@",URL);
    NSString *tmpUrl = URL.absoluteString;
    NSDictionary *urlPara = [Tools getParametersWithUrlString:tmpUrl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:urlPara];
    [dic setObject:tmpUrl forKey:@"url"];
    if (self.requestBlock) {
        self.requestBlock(dic);
    }

    return NO;
}

#pragma mark - 
- (UITextView *)textView {

    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
        _textView.editable = NO;
    }
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    DDLogDebug(@"%@",URL);
    NSString *tmpUrl = URL.absoluteString;
    NSDictionary *urlPara = [Tools getParametersWithUrlString:tmpUrl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:urlPara];
    [dic setObject:tmpUrl forKey:@"url"];
    if (self.requestBlock) {
        self.requestBlock(dic);
    }

    return NO;
}

- (UILabel *)timeLabel {

    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor grayColor];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
