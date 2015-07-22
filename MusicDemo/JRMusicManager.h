//
//  JRMusicManager.h
//  MusicDemo
//
//  Created by Jaben on 15/7/22.
//  Copyright (c) 2015年 xpg. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;

typedef void(^ItemSelectedBlock)(BOOL isCancel, MPMediaItemCollection *mediaItemCollection);

@interface JRMusicManager : NSObject

+ (instancetype)shareManager;
- (NSArray *)musicInDevice;

- (MPMusicPlayerController *)applicationMusicPlayer;
- (MPMusicPlayerController *)systemMusicPlayer;
- (void)goToMusicPickerWithController:(UIViewController *)controller selectCompleted:(ItemSelectedBlock)completed;
@end
