//
//  BATKangDoctorMessageModel.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangMessageModel.h"

@implementation BATDrKangMessageModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _time = [NSDate date];
        _maxWidth = DrKangMaxWidth;
    }
    return self;
}

- (void)setDrkangModel:(BATDrKangModel *)model {

    //康博士回复的消息
    self.type = model.resultData.type;
    
    self.historyKeyValues = model.mj_keyValues;
    
    if ([self.type isEqualToString:@"Me"]) {
        //我发送的消息
        _fromType = BATKangDoctorMessageFromMe;
        _content = model.resultData.body;
        _textHeight = [Tools calculateHeightWithText:_content width:_maxWidth font:[UIFont systemFontOfSize:15]];
        if ([_content containsString:@"（"]) {
            _textHeight += 15;
        }

    }
    else if ([self.type isEqualToString:@"music"]) {
        //康博士-音乐消息类型
        _fromType = BATKangDoctorMessageFromKangDoctor;
        _musicIndex = [Tools getRandomNumber:1 to:5];
        _textWidth = _maxWidth/2.0;
        _textHeight = 30;
    }
    else {
        //康博士-文本消息类型
        _fromType = BATKangDoctorMessageFromKangDoctor;
        _content = model.resultData.body;
        if (![_content containsString:@"</p>"]) {
            _content = [self kangDoctorMessageAddLabel:_content];
        }

        _htmlAttributedStr = [self htmlAttributedStringWihtHtmlStr:_content];
        _textHeight = [Tools getHeightForAttributedText:_htmlAttributedStr textWidth:_maxWidth];
        float tmpWidth = [Tools getWidthForAttributedText:_htmlAttributedStr textHeight:_textHeight];

        _textHeight += 2;
        
        if ([_content containsString:@"border-bottom"]) {
            tmpWidth += 70;
            _textHeight += 20;
        }

        if ([_content containsString:@"展开详情"]) {

            _textHeight -= 60;
        }
        
        _textWidth =  tmpWidth+20 < _maxWidth ? tmpWidth+20 : _maxWidth;
        _textWidth +=20;
    }
}

- (NSMutableAttributedString *)htmlAttributedStringWihtHtmlStr:(NSString *)htmlStr {

//    if ([htmlStr containsString:@"border-bottom"]) {
//
//        NSRange firstSpaceRange = [htmlStr rangeOfString:@"</p>"];
//        if (firstSpaceRange.location != NSNotFound) {
//
//            htmlStr = [NSString stringWithFormat:@"%@%@%@",[htmlStr substringToIndex:firstSpaceRange.location],@"</p><p style=\"margin: 0;color: #333;font-size: 11px;line-height: 11px;\">————————————",[htmlStr substringFromIndex:firstSpaceRange.location]];
//        }
//    }

    NSMutableAttributedString *htmlAttributedStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    return htmlAttributedStr;
}

//添加标签
- (NSString *)kangDoctorMessageAddLabel:(NSString *)content {

    NSString *font = @"<p style=\"float:left;padding: 0 0 0 10px;font-size: 15px;color: #333;margin:0;line-height: 22px;\">";
    content = [font stringByAppendingString:content];
    content = [content stringByAppendingString:@"</p>"];

    return content;
}


@end
