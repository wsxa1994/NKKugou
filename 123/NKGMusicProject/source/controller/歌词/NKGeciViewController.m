//
//  NKGeciViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/29.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKGeciViewController.h"
#import "NKPlaylistTool.h"
@interface NKGeciViewController ()<UITableViewDataSource,UITableViewDelegate,NKPlayBarDelegate>
{
    NSArray* _geciArray;
    NSIndexPath * _curIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NKGeciViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [img setImage:[UIImage imageNamed:@"hehe"]];
    [self.view addSubview:img];
    _tableView.separatorColor = [UIColor clearColor];
    [img addSubview:_tableView];
    //调整导航栏不遮挡tableview
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"歌词";
    img.userInteractionEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{

//    NSLog(@"歌词是: %@",_geciName);
    _geciArray = [NKPlaylistTool sharedNKPlaylistTool].curGeciDict[@"real"];
    [_tableView reloadData];
    [NKPlayBar sharePlayBar].delegate = self;
    _curIndexPath = nil;
    
}
-(void)playBar:(NKPlayBar *)playBar didGeciChanged:(NSInteger)index{
    //根据匹配歌词的index 更新tableview中的cell
    index+= 1;
    if (_curIndexPath != nil) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_curIndexPath];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor yellowColor];
    _curIndexPath = indexPath;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _geciArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"geciCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.textLabel.text = _geciArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //一行的字数较多时能自动换行
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:18];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
