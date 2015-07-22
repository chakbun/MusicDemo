//
//  ViewController.m
//  MusicDemo
//
//  Created by Jaben on 15/4/3.
//  Copyright (c) 2015年 xpg. All rights reserved.
//

#import "ViewController.h"
#import "JRMusicManager.h"
@import MediaPlayer;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) NSArray *songs;

@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Music";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.songs = [[JRMusicManager shareManager] musicInDevice];
    
    self.musicPlayer = [[JRMusicManager shareManager] systemMusicPlayer];
    
    self.musicTableView.tableFooterView = [[UIView alloc] init];
    [self.musicTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)musicButtonAction:(id)sender {
    [[JRMusicManager shareManager] goToMusicPickerWithController:self selectCompleted:^(BOOL isCancel, MPMediaItemCollection *mediaItemCollection) {
        
        if (isCancel) {
//            MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 500)];
//            volumeView.showsRouteButton = YES;
//            volumeView.showsVolumeSlider = YES;
//            [self.view addSubview:volumeView];
        }else {
            for(MPMediaItem *item in mediaItemCollection.items) {
                NSLog(@"%@",item.title);
                NSLog(@"%@",item.albumTitle);
                NSLog(@"%@",item.artist);
                NSLog(@"%@",item.releaseDate);
                NSLog(@"%ld",item.playCount);
            }
            [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
            [self.musicPlayer play];
        }
    }];
}

#pragma mark - TabelView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *mediaItem = self.songs[indexPath.row];
    
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:@[mediaItem]];
    MPMediaItem *item = [collection representativeItem];
    
    [self.musicPlayer setQueueWithItemCollection:collection];
    [self.musicPlayer setNowPlayingItem:item];
    
    [self.musicPlayer prepareToPlay];
    
    [self.musicPlayer play];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - TabelView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicItem"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MusicItem"];
    }
    MPMediaItem *mediaItem = self.songs[indexPath.row];
    cell.textLabel.text = mediaItem.title;
    return cell;
}

@end
