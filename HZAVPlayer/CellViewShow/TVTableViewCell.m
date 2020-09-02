//
//  TVTableViewCell.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "TVTableViewCell.h"
#import <Masonry/Masonry.h>
@interface TVTableViewCell()

@property(nonatomic,strong) UIView *tvView;
@property(nonatomic,strong) UIButton *playeBtn;

@property(nonatomic,strong) UILabel *title;

@end

@implementation TVTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self layout];
    }
    return self;
}

-(void)layout{
    
    
    _title = [[UILabel alloc] init];
    _title.textColor = [UIColor blackColor];
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self.contentView).equalTo(@15);
        make.right.equalTo(self.contentView).equalTo(@-15);
        make.height.equalTo(@30);
    }];
    
    _tvView = [[UIView alloc] init];
    _tvView.layer.masksToBounds = YES;
    [self.contentView addSubview:_tvView];
    //这个可以改为ImageView 根据后台返回的url来显示
    _tvView.layer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"bg_zhanweifu_375180"].CGImage;
    [_tvView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.mas_bottom).equalTo(@15);
        make.left.equalTo(self.contentView).equalTo(@15);
        make.bottom.right.equalTo(self.contentView).equalTo(@-15);
    }];
    
    [self.tvView addSubview:self.playeBtn];
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@44);
        make.height.equalTo(@44);
        make.centerX.equalTo(self.tvView);
        make.centerY.equalTo(self.tvView);
    }];
}

-(void)titleWithContent:(NSString *)title{
    
    _title.text = title;
}

-(void)playerAction{
    
    
    if ([_delegate respondsToSelector:@selector(tvTabelViewActionWithShowView:indexPath:)]) {
        _playeBtn.hidden = YES;
        [_delegate tvTabelViewActionWithShowView:self.tvView indexPath:_indexPath];
    }
}

-(void)hz_playStop{
    
    _tvView.layer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"bg_zhanweifu_375180"].CGImage;
    _playeBtn.hidden = NO;
}

+(void)registerCellWithTabelView:(UITableView *)tableView{
    
    [tableView registerClass:self.class forCellReuseIdentifier:[self cellName]];
}


+(NSString *)cellName{
    
    return NSStringFromClass(self.class);
}

-(UIButton *)playeBtn{
    
    if (_playeBtn == nil) {
        _playeBtn = [[UIButton alloc] init];
//        [_playeBtn setImage:hz_shoppingMallImageWithName(@"HZShoppingMall_Playe", [self class]) forState:UIControlStateNormal];
        [_playeBtn setImage:[UIImage imageNamed:@"home_btn_tv_play"] forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(playerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}

@end
