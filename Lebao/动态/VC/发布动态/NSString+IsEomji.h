//
//  NSString+IsEomji.h
//  Lebao
//
//  Created by adnim on 16/11/21.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsEomji)
+ (BOOL)isContainsTwoEmoji:(NSString *)string;
@end
