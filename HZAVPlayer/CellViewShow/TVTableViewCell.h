//
//  TVTableViewCell.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVTableViewDelegate  <NSObject>

 @optional

-(void)tvTabelViewActionWithShowView:(UIView *)showView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TVTableViewCell : UITableViewCell


-(void)titleWithContent:(NSString *)title;

@property(nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,weak) id<TVTableViewDelegate> delegate;

+(void)registerCellWithTabelView:(UITableView *)tableView;

+(NSString *)cellName;


-(void)hz_playStop;

@end

NS_ASSUME_NONNULL_END
