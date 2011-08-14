//
//  SodateAAListViewController.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/07/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SodateAAListViewController.h"

@implementation SodateAAListViewController

@synthesize updateViewDelegate;

@synthesize _dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadData];
    }
    return self;
}

// 以下 TableViewDelegate用メソッド
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    if (_dataArray.count == 0) {
        return cell;
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"aaString"];
    cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0];
    cell.detailTextLabel.text = [dict objectForKey:@"barcodeString"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_dataArray forKey:@"aaDataList"];
    [defaults synchronize];
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [updateViewDelegate updateView:dict];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSInteger row = [indexPath row];
    [_dataArray removeObjectAtIndex:row];
    [resultTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

//- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
//    return @"保存した顔文字一覧";
//}

// 以上 TableViewDelegate用メソッド

/**
 * データをロードする
 */
- (void)loadData;
{
    // 保存されているデータリストを取得
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self._dataArray = [defaults mutableArrayValueForKey:@"aaDataList"];
    if (_dataArray == nil) {
        // データがない場合リストを新規生成
        _dataArray = [NSMutableArray array];
    }
}

/**
 * 前画面に戻る
 */
- (IBAction) backButtonTapped
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_dataArray forKey:@"aaDataList"];
    [defaults synchronize];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.updateViewDelegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
