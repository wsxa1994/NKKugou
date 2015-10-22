//
//  NKMainViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKMainViewController.h"
#import "UIView+NKMoreAttribute.h"
#import "UIViewController+NKStoryBoard.h"
#import "NSArray+NKPlist.h"
//区别不同模式的美剧类型
typedef enum musicMode{
    musicModeLocal,
    musicModeWeb,
    musicModeMore

}musicMode;
@interface NKMainViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSArray *_webMusicArray;
    musicMode  _mode;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *midImgView;
@property (weak, nonatomic) IBOutlet UIImageView *botImgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
- (IBAction)netMusicBtnClick:(UIButton *)sender;
- (IBAction)moreBtnClick:(UIButton *)sender;
- (IBAction)myMuiscBtnClick:(UIButton *)sender;
- (IBAction)iconBtnClick:(UIButton *)sender;
- (IBAction)LoginBtnClick:(UIButton *)sender;
- (IBAction)siginBtnClick:(UIButton *)sender;
- (IBAction)upBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation NKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.@""
 
    _topImgView.hidden = NO;
    _midImgView.hidden = YES;
    _botImgView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"myMusicCell.plist" withExtension:nil];
    NSArray *myMusicListArray = [NSArray arrayWithContentsOfURL:url];
        _myMusicListArray = myMusicListArray;
    
    
    //网络选择数组
    NSArray * webMusicArray = [NSArray arrayWithPlist:@"netMusic.plist"];
    _webMusicArray = webMusicArray;

    

        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)netMusicBtnClick:(UIButton *)sender {
    _botImgView.hidden = NO;
    _topImgView.hidden = YES;
    _midImgView.hidden = YES;
    
    //刷新

    _mode = musicModeWeb;
        [_tableView reloadData];

    
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    _midImgView.hidden = NO;
    _botImgView.hidden = YES;
    _topImgView.hidden = YES;
    

}

- (IBAction)myMuiscBtnClick:(UIButton *)sender {
    _topImgView.hidden =NO;
    _midImgView.hidden = YES;
    _botImgView.hidden = YES;
    

    _mode = musicModeLocal;
        [_tableView reloadData];

    
}

- (IBAction)iconBtnClick:(UIButton *)sender {
}

- (IBAction)LoginBtnClick:(UIButton *)sender {
    
}

- (IBAction)siginBtnClick:(UIButton *)sender {
}

- (IBAction)upBtnClick:(UIButton *)sender {
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (_mode) {
        case musicModeLocal:
        {
            return _myMusicListArray.count;
            break;
        }
            case musicModeWeb:
        {
            return _webMusicArray.count;
        }
            default:
            return 0;
            break;
            

    }
    
    return 0;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    

    if (_curselCell != nil ) {
        _curselCell.textLabel.textColor = [UIColor whiteColor];
    }
    //选中当前行的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor yellowColor];
    
    _curselCell = cell;

    
    switch (_mode) {
        case musicModeLocal:
            [self handleLocalMusic:indexPath.row ];
            break;
            case musicModeWeb:
            [self handleWebMusic:indexPath.row];
            break;
            
        default:
            break;
    }
    
    
    
    
   }
-(void)handleLocalMusic:(NSInteger)row{
    
        UIViewController *vc = [UIViewController viewControllerWithStroyBoardID:@"bendiViewController1"];
    switch (row) {
        case 0:
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 1:
            NSLog(@"1");
        case 2:
               NSLog(@"2");
           
            break;
        case 3:
             [self performSegueWithIdentifier:@"xiazai" sender:self];
         
            break;
        case 4:
            NSLog(@"4");
            break;
        case 5:
            NSLog(@"5");
            break;
            
        default:
            break;
    }


}
-(void)handleWebMusic:(NSInteger)row{

    
//    UIViewController *vc = [UIViewController viewControllerWithStroyBoardID:@"singerViewController1"];
    switch (row) {
        case 0:
//            [self.navigationController pushViewController:vc animated:YES];
            [self performSegueWithIdentifier:@"geshou" sender:self];
            break;
        case 1:
            
            [self performSegueWithIdentifier:@"diantai" sender:self];
            NSLog(@"电台");

            
        default:
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    
    switch (_mode) {
        case musicModeLocal:
        {
       cell.textLabel.text = _myMusicListArray[indexPath.row];
            break;
        }
        case musicModeWeb:
        {
            cell.textLabel.text = _webMusicArray[indexPath.row];
            break;
        }
        default:
    
            break;
            
    }
    
//        cell.textLabel.text = _myMusicListArray[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

}


@end
