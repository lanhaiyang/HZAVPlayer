//
//  CellPlayerManage.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HZ_ActionUserStopCellTV,
} HZ_ActionUserState;

@protocol CellPlayerDelegate  <NSObject>

 @optional

-(void)cellPlayerWithState:(HZ_ActionUserState)state indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CellPlayerManage : NSObject


@property(nonatomic,weak) id<CellPlayerDelegate> delegate;

@property(nonatomic,strong,readonly) NSIndexPath *playeIndexPath;
@property(nonatomic,strong,readonly) NSIndexPath *playeOldIndexPath;

-(void)hz_playeWithUrl:(NSString *)url crosswise:(UIView *)crosswiseView vertical:(UIView *)superView playeIndexPath:(NSIndexPath *)indexPath;


-(void)hz_huaZhenTVScrollViewSlideBegin;

-(void)hz_huaZhenTVScrollViewSlideEnd;


-(void)hz_playeStop;

-(void)huazhenTVPlayerStop;

-(void)hz_playe;

-(void)hz_pause;

/// 删除 playeOldIndexPath
-(void)hz_removeOldIndexPath;

@end

NS_ASSUME_NONNULL_END
