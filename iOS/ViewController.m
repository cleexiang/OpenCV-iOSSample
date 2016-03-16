//
//  ViewController.m
//  iOS
//
//  Created by clee on 16/3/16.
//  Copyright © 2016年 cleexiang. All rights reserved.
//

#import "ViewController.h"

#import "BlendViewController.h"

@interface MyCell : UITableViewCell

@end

@implementation MyCell

@end

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"Blend";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlendViewController *vc = [BlendViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
