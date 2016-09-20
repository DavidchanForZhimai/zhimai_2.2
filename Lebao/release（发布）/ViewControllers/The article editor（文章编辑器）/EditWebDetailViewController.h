//
//  EditWebDetailViewController.h
//  Lebao
//
//  Created by David on 16/3/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "ZSSRichTextEditor.h"
typedef void (^HtmlBlock)(NSString *str);
@interface EditWebDetailViewController : ZSSRichTextEditor
@property(nonatomic,strong)NSString *titles;

@property(nonatomic,strong)NSString *htmlStr;
@property(nonatomic,copy) HtmlBlock htmlBlock;
@end
