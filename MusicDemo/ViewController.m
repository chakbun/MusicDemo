//
//  ViewController.m
//  MusicDemo
//
//  Created by Jaben on 15/4/3.
//  Copyright (c) 2015年 xpg. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController ()<MPMediaPickerControllerDelegate>
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MPMediaQuery *allMusic = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:@(MPMediaTypeMusic) forProperty:MPMediaItemPropertyMediaType];
    [allMusic addFilterPredicate:predicate];
    
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [allMusic items];
    NSLog(@"count = %lu", (unsigned long)itemsFromGenericQuery.count);
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
        NSLog (@"Title:%@, Aritist:%@", songTitle, songArtist);
    }
    
    self.musicPlayer = [MPMusicPlayerController  applicationMusicPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)musicButtonAction:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
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

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 500)];
    volumeView.showsRouteButton = YES;
    volumeView.showsVolumeSlider = YES;
    [self.view addSubview:volumeView];
}

@end
