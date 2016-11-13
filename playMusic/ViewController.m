//
//  ViewController.m
//  playMusic
//
//  Created by lingo on 16/11/8.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+LGExtension.h"
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW [UIScreen mainScreen].bounds.size.width

#define PlayMagin 20

@interface ViewController ()
/** 背景 */
@property (nonatomic, weak) UIImageView *bgImageView;
/** 背景上的碟片 */
@property (nonatomic, weak) UIImageView *musicDishImageView;
/**加载时间 */
@property (nonatomic, weak) UIProgressView *loadProgressView;
/** 加载进度条 */
@property (nonatomic, weak) UISlider *playSlider;
/** 播放进度条 */
@property (nonatomic, weak) UILabel *playTimeLabel;
/** 总时间 */
@property (nonatomic, weak) UILabel *totalTimeLabel;
/** 播放/暂停 按钮 */
@property (nonatomic, weak) UIButton *playBtn;
/** 上一曲 */
@property (nonatomic, weak) UIButton *preMusicBtn;
/** 下一曲 */
@property (nonatomic, weak) UIButton *nextMusicBtn;

/** 音乐播放器 */
@property (nonatomic, strong) AVPlayer *musicPlayer;
//当前歌曲进度监听者
@property(nonatomic,strong) id timeObserver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

#pragma mark - lazy

- (AVPlayer *)musicPlayer{
    if (!_musicPlayer) {
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@""]];
        _musicPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    }
    return _musicPlayer;
}

- (void)setupUI{
    //背景
    UIImageView *bgImageView = [[UIImageView alloc] init];
    self.bgImageView = bgImageView;
    [self.view addSubview:bgImageView];
    bgImageView.frame = self.view.bounds;
    bgImageView.image = [UIImage imageNamed:@"eason_icon"];
    //设置毛玻璃效果
    [self setBlurView];

    //背景上转动的碟片
    UIImageView *musicDishImageView = [[UIImageView alloc] init];
    self.musicDishImageView = musicDishImageView;
    [self.view addSubview:musicDishImageView];
    musicDishImageView.frame = CGRectMake((ScreenW - 240)/2,ScreenH/4, 240, 240);
    musicDishImageView.image = [UIImage imageNamed:@"eason_icon"];
    musicDishImageView.layer.cornerRadius = musicDishImageView.frame.size.width/2.0f;
    musicDishImageView.layer.masksToBounds = YES;
    [self addAnimationToMusicDish];
    //加载进度
    UIProgressView *loadProgressView = [[UIProgressView alloc] init];
    loadProgressView.progressTintColor = [UIColor blueColor];
    loadProgressView.trackTintColor = [UIColor grayColor];
    [loadProgressView setProgress:0.5];
    self.loadProgressView = loadProgressView;
    [self.view addSubview:loadProgressView];
    loadProgressView.frame = CGRectMake(40, CGRectGetMaxY(musicDishImageView.frame)+40,ScreenW - 2*40, 5);
    //当前进度
    UISlider *playSlider = [[UISlider alloc] init];
    playSlider.minimumTrackTintColor = [UIColor redColor];
    playSlider.maximumTrackTintColor = [UIColor clearColor];
    self.playSlider  = playSlider;
    [self.view addSubview:playSlider];
    playSlider.value = 0.3;
    playSlider.frame = loadProgressView.frame;
    //播放时间
    UILabel *playTimeLabel = [[UILabel alloc] init];
    playTimeLabel.text = @"10:10";
    playTimeLabel.textColor = [UIColor whiteColor];
    playTimeLabel.textAlignment = NSTextAlignmentCenter;
    playTimeLabel.font = [UIFont systemFontOfSize:9.0f];
    self.playTimeLabel = playTimeLabel;
    [self.view addSubview:playTimeLabel];
    playTimeLabel.frame = CGRectMake(0, loadProgressView.lg_y-2.5, 40, 10);
    //总时间
    UILabel *totalTimeLabel = [[UILabel alloc] init];
    totalTimeLabel.text = @"10:10";
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    totalTimeLabel.font = [UIFont systemFontOfSize:9.0f];
    self.totalTimeLabel = totalTimeLabel;
    [self.view addSubview:totalTimeLabel];
    totalTimeLabel.frame = CGRectMake(CGRectGetMaxX(loadProgressView.frame), loadProgressView.lg_y-2.5, 40, 10);
    
    //播放/暂停
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateSelected];
    self.playBtn = playBtn;
    [self.view addSubview:playBtn];
    playBtn.frame = CGRectMake(ScreenW/2.0f - 32,ScreenH - 100, 64,64);
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //上一曲
    UIButton *preMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preMusicBtn setImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
    self.preMusicBtn = preMusicBtn;
    [self.view addSubview:preMusicBtn];
    preMusicBtn.frame = CGRectMake(playBtn.lg_x - 64 - PlayMagin, playBtn.lg_y, 64, 64);
    [preMusicBtn addTarget:self action:@selector(preMusicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //下一曲
    UIButton *nextMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextMusicBtn setImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    self.nextMusicBtn = nextMusicBtn;
    [self.view addSubview:nextMusicBtn];
    nextMusicBtn.frame = CGRectMake(playBtn.lg_x + 64 + PlayMagin, playBtn.lg_y, 64, 64);
    [nextMusicBtn addTarget:self action:@selector(nextMusicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 播放，上一曲，下一曲
- (void)playBtnClick:(UIButton *)btn{
    if (!btn.selected) {//当前是暂停状态，点一下让它播放
        btn.selected = YES;
        [self playerMusicWithUrl:@"http://download.lingyongqian.cn/music/MoonlightSonata.mp3"];
    }else{//当前是播放状态，点一下要暂停
        [self.musicPlayer pause];
        btn.selected = NO;
        [self removePlayStatus];
        [self removePlayLoadTime];
    }
}

//上一曲
- (void)preMusicBtnClick:(UIButton *)sender{
    [self playerMusicWithUrl:@"http://download.lingyongqian.cn/music/MinuetInG.mp3"];
    [self removePlayStatus];
    [self removePlayLoadTime];

}

//下一曲
- (void)nextMusicBtnClick:(UIButton *)sender{
    [self playerMusicWithUrl:@"http://download.lingyongqian.cn/music/ViolinConcertoOp61InDMajorIII.mp3"];
    [self removePlayStatus];
    [self removePlayLoadTime];

}

#pragma mark - 播放进度

- (void)addAnimationToMusicDish{
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设定动画选项
    animation.duration = 5; // 持续时间
    animation.repeatCount = NSIntegerMax; // 重复次数
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI]; // 终止角度
    // 添加动画
    [self.musicDishImageView.layer addAnimation:animation forKey:@"rotate-layer"];
}

- (void)playerMusicWithUrl:(NSString *)urlString{
    NSURL *playUrl = [NSURL URLWithString:urlString];
    AVPlayerItem *currPlayerItem = [AVPlayerItem playerItemWithURL:playUrl];

    [self.musicPlayer replaceCurrentItemWithPlayerItem:currPlayerItem];
    
    [self.musicPlayer play];
    
    [self addPlayStatus];
    
    [self addPlayLoadTime];
    
    [self addMusicProgressWithItem:currPlayerItem];
}

- (void)setBlurView
{
    UIToolbar *blurView = [[UIToolbar alloc] init];
    blurView.barStyle = UIBarStyleBlack;
    blurView.frame = self.view.bounds;
    [self.bgImageView addSubview:blurView];
}

#pragma mark - 监听音乐各种状态
//通过KVO监听播放器状态
-(void)addPlayStatus
{
    
    [self.musicPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
//移除监听播放器状态
-(void)removePlayStatus
{
    [self.musicPlayer.currentItem removeObserver:self forKeyPath:@"status"];
}



//KVO监听音乐缓冲状态
-(void)addPlayLoadTime
{
    [self.musicPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}
//移除监听音乐缓冲状态
-(void)removePlayLoadTime
{
    [self.musicPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

//监听音乐播放的进度
-(void)addMusicProgressWithItem:(AVPlayerItem *)item
{
    //移除监听音乐播放进度
    [self removeTimeObserver];
    __weak typeof(self) weakSelf = self;
    self.timeObserver =  [self.musicPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        //总时间
        float total = CMTimeGetSeconds(item.duration);
        if (current) {
            float progress = current / total;
            NSLog(@"当前播放时间：%f 总时间：%f 播放进度：%f",current,total,progress);
            //更新播放进度条
            weakSelf.playSlider.value = progress;
            weakSelf.playTimeLabel.text = [weakSelf timeFormatted:current];
        }
    }];
}

//转换成时分秒
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}
//移除监听音乐播放进度
-(void)removeTimeObserver
{
    if (self.timeObserver) {
        [self.musicPlayer removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

//观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context

{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.musicPlayer.status) {
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray * timeRanges = self.musicPlayer.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.musicPlayer.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        NSLog(@"总时长：%f-%f-缓冲百分比：%f",totalLoadTime,duration,scale);
        //更新缓冲进度条
        self.loadProgressView.progress = scale;
    }
}



@end
