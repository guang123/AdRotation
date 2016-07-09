//
//  ADView.h
//  OC
//
//  Created by 鲁曦广 on 16/7/8.
//  Copyright © 2016年 CIeNET. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCRREENWIDTH [[UIScreen mainScreen] bounds].size.width
@protocol ADViewDelegate <NSObject>

- (void)seleADPage:(NSInteger)page;

@end

@interface ADView : UIView

@property (strong, nonatomic) NSMutableArray *arrImagerURL;

@property (assign, nonatomic) id<ADViewDelegate> delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (instancetype)initWithFrame:(CGRect)frame;
@end
