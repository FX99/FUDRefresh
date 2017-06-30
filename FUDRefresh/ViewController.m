//
//  ViewController.m
//  FUDRefresh
//
//  Created by fudo on 2017/6/30.
//  Copyright © 2017年 fudo. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+FUDRefresh.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    tableview.backgroundColor = [UIColor greenColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [tableview addHeaderWithHandle:^() {
        NSLog(@"freshing...");
    }];
    
    [self.view addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld行，我好欢乐呀～", (long)indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"****** %@ dealloc ******", [self class]);
}

@end
