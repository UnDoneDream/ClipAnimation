//
//  ViewController.m
//  iOS_卡牌动画01
//
//  Created by 高宇 on 16/11/18.
//  Copyright © 2016年 高宇. All rights reserved.
//

#import "ViewController.h"
#define iOS_Scale [[UIScreen mainScreen] bounds].size.width/320

@interface ViewController ()<UIScrollViewDelegate>
{
    NSInteger _index;
    BOOL _isRight;
}

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ViewController

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageArray;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100 * iOS_Scale, 320 * iOS_Scale, 280 * iOS_Scale)];
        _scrollView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.3];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡牌动画";
    _index = 0;
    _isRight = YES;
    [self setBaseImageView];
    [self setTwoButton];
}

- (void) setBaseImageView
{
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:[[NSBundle mainBundle] pathForResource:@"IMAGE" ofType:nil]];
    self.scrollView.contentSize = CGSizeMake((array.count - 1) * 55 * iOS_Scale + 154 * iOS_Scale + 100 * iOS_Scale, 0);
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < array.count; i++) {
        NSString *imageString = [array[i] componentsSeparatedByString:@"/"].lastObject;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageString]];
        imageView.tag = i;
        imageView.layer.cornerRadius = 10;
        imageView.layer.borderWidth = 5;
        imageView.layer.borderColor = [UIColor yellowColor].CGColor;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:tapRecognizer];
        
        if (i == 0) {
            imageView.frame = CGRectMake(0, 0, 154 * iOS_Scale, 280 * iOS_Scale);
            imageView.center = CGPointMake(160 * iOS_Scale, 140 * iOS_Scale);
        }else{
            UIImageView *lastImageView = self.imageArray.lastObject;
            if (i == 1) {
                imageView.frame = CGRectMake(CGRectGetMaxX(lastImageView.frame) - 20 * iOS_Scale, 20 * iOS_Scale, 154 * iOS_Scale, 230 * iOS_Scale);
            }else{
                imageView.frame = CGRectMake(lastImageView.frame.origin.x + 15 * iOS_Scale, 20 * iOS_Scale, 144 * iOS_Scale, 230 * iOS_Scale);
            }
            CATransform3D t = CATransform3DIdentity;
            t.m34 = 4.5/-2000;
            t = CATransform3DRotate(t, M_PI/2*3/4, 0, 1, 0);
            imageView.layer.transform = t;
        }
        [self.scrollView addSubview:imageView];
        [self.imageArray addObject:imageView];
    }
}

- (void)imageClick:(UITapGestureRecognizer *)tapRecognizer
{
    NSInteger viewTag = tapRecognizer.view.tag;
    if (_index == viewTag) {
        return ;
    }
    if (_index < viewTag) {
        _isRight = YES;
    }else{
        _isRight = NO;
    }
    [self updateFrameForVisilablyWith:viewTag];
    _index = viewTag;
}

- (void)setTwoButton
{
    NSArray *array = [NSArray arrayWithObjects:@"上一张", @"下一张", nil];
    for (int i = 0 ; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 * iOS_Scale + i * (320 - 80) *iOS_Scale , CGRectGetMaxY(self.scrollView.frame) + 10, 70, 34);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor yellowColor];
        button.layer.cornerRadius = 2.5;
        button.layer.masksToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag==0&&_index>0) {
        _index--;
        _isRight = NO;
        
    }else if(sender.tag==1&&_index<self.imageArray.count-1){
        _index++;
        _isRight = YES;
    }else{
        return;
    }
    [self updateFrameForVisilablyWith:_index];
}

-  (void)updateFrameForVisilablyWith:(NSInteger )viewTag
{
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageView = self.imageArray[i];
        if (i == viewTag) {
            CATransform3D t = CATransform3DIdentity;
            t.m34 = 4.5/-2000;
            t = CATransform3DRotate(t, 0, 0, 1, 0);
            [UIView animateWithDuration:0.5 animations:^{
                if (i==0) {
                    imageView.frame = CGRectMake(0, 0, 154 * iOS_Scale, 280 * iOS_Scale);
                    imageView.center = CGPointMake(160 * iOS_Scale, 140 * iOS_Scale);
                }else{
                    UIImageView *ima = self.imageArray[i - 1];
                    imageView.frame = CGRectMake(ima.frame.origin.x + 80 * iOS_Scale, 0, 154 * iOS_Scale, 280 * iOS_Scale);
                }
                imageView.layer.transform = t;
            }];
        }else if (i<viewTag){
            CATransform3D t = CATransform3DIdentity;
            t.m34 = 4.5/-2000;
            t = CATransform3DRotate(t, -M_PI / 2 * 3 / 4, 0, 1, 0);
            [UIView animateWithDuration:0.5 animations:^{
                imageView.layer.transform = t;
                imageView.frame = CGRectMake(55 * i * iOS_Scale + 30 * iOS_Scale, 20 * iOS_Scale, 144 * iOS_Scale, 230 * iOS_Scale);
            }];
        }else if (i>viewTag){
            CATransform3D t = CATransform3DIdentity;
            t.m34 = 4.5/-2000;
            t = CATransform3DRotate(t, M_PI / 2 * 3 / 4, 0, 1, 0);
            [UIView animateWithDuration:0.5 animations:^{
                imageView.layer.transform = t;
                imageView.frame = CGRectMake(55 * (i - 1) * iOS_Scale + 30 * iOS_Scale + 154 * iOS_Scale + 55 * iOS_Scale, 20 * iOS_Scale, 144 * iOS_Scale, 230 * iOS_Scale);
            }];
        }
    }
    UIImageView *imaa = self.imageArray[viewTag];
    _scrollView.contentOffset = CGPointMake(imaa.frame.origin.x-85, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
