//
//  ViewController.m
//  test1
//
//  Created by 杨雷 on 2016/10/30.
//  Copyright © 2016年 Yang.L. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AppModel.h"
#import "UIImageView+WebCache.h"


static NSString *cellID = @"cellID";
@interface ViewController ()
@property(nonatomic,strong)NSOperationQueue * queue;

@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation ViewController
- (NSOperationQueue *)queue
{
    if (!_queue)
    {
        _queue = [NSOperationQueue new];
        
    }
    return _queue;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadJsonData];
    
    
    
}
- (void)loadJsonData
{
    
    //创建网络管理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://raw.githubusercontent.com/Yang01083/YangTest1/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@ %@",[responseObject class],responseObject);
        
        NSMutableArray *mArr = [NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            AppModel *model = [AppModel appWithDict:obj];
            
            [mArr addObject:model];
            
            
        }];
        self.dataArray = mArr.copy;
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    AppModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    cell.detailTextLabel.text = model.download;
    
    cell.imageView.image = [UIImage imageNamed:@"user_default"];
    
    //    NSURL *url = [NSURL URLWithString:model.icon];
    //
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //
    //    UIImage *image = [UIImage imageWithData:data];
    //
    //    cell.imageView.image = image;
    
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:model.icon];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            cell.imageView.image = image;
            
        }];
        
    }];
    
    [self.queue addOperation:op];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
