//
//  ViewController.m
//  AdRotation
//
//  Created by 鲁曦广 on 16/7/8.
//  Copyright © 2016年 CIeNET. All rights reserved.
//

#import "ViewController.h"
#import "ADView.h"

@interface ViewController ()
@property (strong, nonatomic) ADView *adView;
@property (weak, nonatomic) IBOutlet ADView *adOtherView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //ADView 适用代码，autoSize,autoLayout布局
    _adView = [[ADView alloc] initWithFrame:CGRectMake(0, 20, SCRREENWIDTH, 200)];
    NSString *str1 = @"http://images.cnitblog.com/i/450136/201406/011649448847630.png";
    NSString *str2 = @"http://images.cnitblog.com/i/450136/201406/011647543847655.png";
    NSString *str3 = @"http://images0.cnblogs.com/blog2015/468221/201506/230252275805912.png";
    _adView.arrImagerURL = [NSMutableArray arrayWithObjects:str2,str1, str3,nil];
    [self.view addSubview:_adView];
    /*
    NSString *str11 = @"http://images.cnitblog.com/i/450136/201406/011649448847630.png";
    NSString *str12 = @"http://images.cnitblog.com/i/450136/201406/011647543847655.png";
    NSString *str13 = @"http://images0.cnblogs.com/blog2015/468221/201506/230252275805912.png";
    _adOtherView.arrImagerURL = [NSMutableArray arrayWithObjects:str12,str11, str13,nil];
    [self.view addSubview:_adOtherView];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
