//
//  JRMusicManager.m
//  MusicDemo
//
//  Created by Jaben on 15/7/22.
//  Copyright (c) 2015年 xpg. All rights reserved.
//

#import "JRMusicManager.h"

@interface JRMusicManager ()<MPMediaPickerControllerDelegate>
@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, strong) ItemSelectedBlock itemSelectedBlock;
@end

@implementation JRMusicManager

+ (instancetype)shareManager {
    static JRMusicManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager =[[JRMusicManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSLog(@"Loading items from a generic query...");

        MPMediaQuery *allMusic = [[MPMediaQuery alloc] init];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:@(MPMediaTypeMusic) forProperty:MPMediaItemPropertyMediaType];
        
        [allMusic addFilterPredicate:predicate];
        
        _songs = [allMusic items];
        
        NSLog(@"Music count = %lu", (unsigned long)_songs.count);

//        for (MPMediaItem *song in _songs)
//        {
//            NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//            NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
//            NSLog (@"Title:%@, Aritist:%@", songTitle, songArtist);
//        }
        
    }
    return self;
}

#pragma mark - Delegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if (self.itemSelectedBlock) {
        self.itemSelectedBlock(NO, mediaItemCollection);
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.itemSelectedBlock) {
        self.itemSelectedBlock(YES, nil);
    }
}


#pragma mark - Public

- (NSArray *)musicInDevice {
    return self.songs;
}

- (MPMusicPlayerController *)applicationMusicPlayer {
    return [MPMusicPlayerController applicationMusicPlayer];
}

- (MPMusicPlayerController *)systemMusicPlayer {
    return [MPMusicPlayerController systemMusicPlayer];
}

- (void)goToMusicPickerWithController:(UIViewController *)controller selectCompleted:(ItemSelectedBlock)completed {
    if (self.itemSelectedBlock) {
        self.itemSelectedBlock = nil;
    }
    self.itemSelectedBlock = completed;
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;

    [controller presentViewController:mediaPicker animated:YES completion:nil];
}

- (void)setApplicationQueueWithItems:(NSArray *)items {
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:items];
    [[self applicationMusicPlayer] setQueueWithItemCollection:collection];
}

- (void)setApplicationQueueWithItemCollection:(MPMediaItemCollection *)collection {
    [[self applicationMusicPlayer] setQueueWithItemCollection:collection];
}

- (void)setApplicationNowPlayingItem:(MPMediaItem *)item {
    [[self applicationMusicPlayer] setNowPlayingItem:item];
}

- (void)setMediaItemInApplicaiton:(MPMediaItem *)item {
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:@[item]];
    MPMediaItem *nowItem = [collection representativeItem];
    
    [[self applicationMusicPlayer] setQueueWithItemCollection:collection];
    [[self applicationMusicPlayer] setNowPlayingItem:nowItem];
    [[self applicationMusicPlayer] prepareToPlay];
}

- (void)playInApplication {
    [[self applicationMusicPlayer] play];
}

- (void)stopInApplication {
    [[self applicationMusicPlayer] stop];
}

@end
