//
//  BlendViewController.m
//  iOS
//
//  Created by clee on 16/3/14.
//  Copyright © 2016年 cleexiang. All rights reserved.
//

#import "BlendViewController.h"
#import <opencv2/opencv.hpp>
#import "UIImage+OpenCV.h"
#import <Masonry.h>

using namespace cv;

@interface BlendViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) UIImageView *orgImageView;
@property (nonatomic) UIImageView *mixedImageView;
@property (nonatomic) NSArray *models;

@property (nonatomic) Mat baseMat;
@property (nonatomic) Mat blendMat;

@end

@implementation BlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[ @{@"变暗" : @"Darken"},
                     @{@"正片叠底" : @"Multiply"},
                     @{@"颜色加深" : @"ColorBurn"},
                     @{@"线性加深" : @"LinearBurn"},
                     @{@"变亮" : @"Lighten"},
                     @{@"滤色" : @"Screen"},
                     @{@"颜色减淡" : @"ColorDodge"},
                     @{@"线性减淡" : @"LinearDodge"},
                     @{@"叠加" : @"Overlay"},
                     @{@"柔光 " : @"SoftLight"},
                     @{@"强光" : @"HardLight"},
                     @{@"亮光" : @"VividLight"},
                     @{@"线性光" : @"LinearLight"},
                     @{@"点光" : @"PinLight"},
                     @{@"实色混合" : @"HardMix"},
                     @{@"差值" : @"Difference"},
                     @{@"排除" : @"Exclusion"},
                     @{@"减去" : @"Subtract"},
                     @{@"划分" : @"Divide"}];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择模式"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(itemAction)];

    self.view.backgroundColor = [UIColor whiteColor];

    UIImage *orgImg = [UIImage imageNamed:@"demo.jpg"];
    self.orgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 80, orgImg.size.width, orgImg.size.height)];
    self.orgImageView.image = orgImg;
    [self.view addSubview:self.orgImageView];

    self.mixedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 320, orgImg.size.width, orgImg.size.height)];
    [self.view addSubview:self.mixedImageView];

    Mat baseMat = [UIImage cvMatFromUIImage:orgImg];
    orgImg = [UIImage imageNamed:@"blend.jpg"];
    self.baseMat = baseMat;
    Mat blendMat = [UIImage cvMatFromUIImage:orgImg];
    self.blendMat = blendMat;

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pickerView.superview.mas_bottom).with.offset(0);
        make.left.equalTo(pickerView.superview.mas_left).with.offset(0);
        make.right.equalTo(pickerView.superview.mas_right).with.offset(0);
        make.height.mas_equalTo(150);
    }];
    pickerView.dataSource = self;
    pickerView.delegate = self;
}

- (void)itemAction {
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pickerView.superview.mas_bottom).with.offset(0);
        make.left.equalTo(pickerView.superview.mas_left).with.offset(0);
        make.right.equalTo(pickerView.superview.mas_right).with.offset(0);
        make.height.mas_equalTo(150);
    }];
    pickerView.dataSource = self;
    pickerView.delegate = self;
}

#pragma mark - UIPickerViewDataSource 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.models.count;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dic = [self.models objectAtIndex:row];
    return [[dic allKeys] firstObject];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Mat mixMat;
    switch (row)
    {
        case 0:
            mixMat = [self DarkenWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 1:
            mixMat = [self MultiplyWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 2:
            mixMat = [self ColorBurnWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 3:
            mixMat = [self LinearBurnWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 4:
            mixMat = [self LightenWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 5:
            mixMat = [self ScreenWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 6:
            mixMat = [self ColorDodgeWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 7:
            mixMat = [self LinearDodgeWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 8:
            mixMat = [self OverlayWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 9:
            mixMat = [self SoftLightWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 10:
            mixMat = [self HardLightWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 11:
            mixMat = [self VividLightWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 12:
            mixMat = [self LinearLightWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 13:
            mixMat = [self PinLightWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 14:
            mixMat = [self HardMixWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 15:
            mixMat = [self DifferenceWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 16:
            mixMat = [self ExclusionWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 17:
            mixMat = [self SubtractWithBaseImage:self.baseMat blend:self.blendMat];
            break;
        case 18:
            mixMat = [self DivideWithBaseImage:self.baseMat blend:self.baseMat];
            break;
        default:
            break;
    }
    self.mixedImageView.image = [UIImage UIImageFromCVMat:mixMat];
}

//变暗
- (Mat)DarkenWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix = Mat(base.rows, base.cols, CV_8UC4);

    for (int j = 0 ; j < base.cols; j++) {
        for (int i = 0 ; i < base.rows; i++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);
            if (bgr1[0] < bgr2[0]) {
                bgr3[0] = bgr1[0];
            } else {
                bgr3[0] = bgr2[0];
            }

            if (bgr1[1] < bgr2[1]) {
                bgr3[1] = bgr1[1];
            } else {
                bgr3[1] = bgr2[1];
            }

            if (bgr1[2] < bgr2[2]) {
                bgr3[2] = bgr1[2];
            } else {
                bgr3[2] = bgr2[2];
            }
            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j,i)) = bgr3;
        }
    }

    return mix;
}

//正片叠底
- (Mat)MultiplyWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix = Mat(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);
            bgr3[0] = bgr1[0]*bgr2[0]/255;
            bgr3[1] = bgr1[1]*bgr2[1]/255;
            bgr3[2] = bgr1[2]*bgr2[2]/255;
            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//颜色加深
- (Mat)ColorBurnWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            if (bgr2[0] == 0)
            {
                bgr3[0] = 0;
            }
            else
            {
                bgr3[0] = MAX(0, bgr1[0] - (255 - bgr1[0]) * (255 - bgr2[0]) / bgr2[0]);
            }

            if (bgr2[1] == 0)
            {
                bgr3[1] = 0;
            }
            else
            {
                bgr3[1] = MAX(0, bgr1[1] - (255 - bgr1[1]) * (255 - bgr2[1]) / bgr2[1]);
            }

            if (bgr2[2] == 0)
            {
                bgr3[2] = 0;
            }
            else
            {
                bgr3[2] = MAX(0, bgr1[2] - (255 - bgr1[2]) * (255 - bgr2[2]) / bgr2[2]);
            }

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;

        }
    }
    return mix;
}

//线性加深
- (Mat)LinearBurnWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MAX(0, bgr1[0] + bgr2[0] - 255);

            bgr3[1] = MAX(0, bgr1[1] + bgr2[1] - 255);

            bgr3[2] = MAX(0, bgr1[2] + bgr2[2] - 255);

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
            
        }
    }
    return mix;
}

//变亮
- (Mat)LightenWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MAX(bgr1[0], bgr2[0]);

            bgr3[1] = MAX(bgr1[1], bgr2[1]);

            bgr3[2] = MAX(bgr1[2], bgr2[2]);

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
            
        }
    }
    return mix;
}

//滤色
- (Mat)ScreenWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = 255 - (255-bgr1[0])*(255-bgr2[0])/255;

            bgr3[1] = 255 - (255-bgr1[1])*(255-bgr2[1])/255;

            bgr3[2] = 255 - (255-bgr1[2])*(255-bgr2[2])/255;

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
            
        }
    }
    return mix;
}

//颜色减淡
- (Mat)ColorDodgeWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            if (bgr2[0] == 255) {
                bgr3[0] = bgr2[0];
            } else {
                bgr3[0] = MIN(255, bgr1[0] + bgr1[0]*bgr2[0]/(255-bgr2[0]));
            }

            if (bgr2[1] == 255) {
                bgr3[1] = bgr2[1];
            } else {
                bgr3[1] = MIN(255, bgr1[1] + bgr1[1]*bgr2[1]/(255-bgr2[1]));
            }

            if (bgr2[2] == 255) {
                bgr3[2] = bgr2[2];
            } else {
                bgr3[2] = MIN(255, bgr1[2] + bgr1[2]*bgr2[2]/(255-bgr2[2]));
            }


            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//线性减淡
- (Mat)LinearDodgeWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MIN(255, bgr1[0] + bgr2[0]);

            bgr3[1] = MIN(255, bgr1[1] + bgr2[1]);

            bgr3[2] = MIN(255, bgr1[2] + bgr2[2]);

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//叠加
- (Mat)OverlayWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            if (bgr1[0] <= 128) {
                bgr3[0] = bgr1[0]*bgr2[0]/128;
            } else {
                bgr3[0] = MAX(0, 255 - (255-bgr1[0])*(255-bgr2[0])/128 );
            }

            if (bgr1[1] <= 128) {
                bgr3[1] = bgr1[1]*bgr2[1]/128;
            } else {
                bgr3[1] = MAX(0, 255 - (255-bgr1[1])*(255-bgr2[1])/128 );
            }

            if (bgr1[2] <= 128) {
                bgr3[2] = bgr1[2]*bgr2[2]/128;
            } else {
                bgr3[2] = MAX(0, 255 - (255-bgr1[2])*(255-bgr2[2])/128 );
            }

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//柔光
- (Mat)SoftLightWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            CGFloat r1 = (CGFloat)bgr1[0];
            CGFloat r2 = (CGFloat)bgr2[0];

            CGFloat g1 = (CGFloat)bgr1[1];
            CGFloat g2 = (CGFloat)bgr2[1];

            CGFloat b1 = (CGFloat)bgr1[2];
            CGFloat b2 = (CGFloat)bgr2[2];

            if (bgr2[0] < 128)
            {
                CGFloat r = r1 * r2 /128 + (r1/255 * r1/255) * (255 - 2 * r2);
                bgr3[0] = floor(r);
            }
            else
            {
                CGFloat r = r1 * (255 - r2)/128 + sqrt(r1/255) * (2 * r2 - 255);
                bgr3[0] = floor(r);
            }

            if (bgr2[1] < 128)
            {
                CGFloat g = g1 * g2 /128 + (g1/255 * g1/255) * (255 - 2 * g2);
                bgr3[1] = floor(g);
            }
            else
            {
                CGFloat g = g1 * (255 - g2)/128 + sqrt(g1/255) * (2 * g2 - 255);
                bgr3[1] = floor(g);
            }

            if (bgr2[2] < 128)
            {
                CGFloat b = b1 * b2 /128 + (b1/255 * b1/255) * (255 - 2 * b2);
                bgr3[2] = floor(b);
            }
            else
            {
                CGFloat b = b1 * (255 - b2)/128 + sqrt(b1/255) * (2 * b2 - 255);
                bgr3[2] = floor(b);
            }
            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//强光
- (Mat)HardLightWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            if (bgr2[0] <= 128) {
                bgr3[0] = bgr1[0]*bgr2[0]/128;
            } else {
                bgr3[0] = 255 - (255-bgr1[0])*(255-bgr2[0])/128;
            }

            if (bgr2[1] <= 128) {
                bgr3[1] = bgr1[1]*bgr2[1]/128;
            } else {
                bgr3[1] = 255 - (255-bgr1[1])*(255-bgr2[1])/128;
            }

            if (bgr2[2] <= 128) {
                bgr3[2] = bgr1[2]*bgr2[2]/128;
            } else {
                bgr3[2] = 255 - (255-bgr1[2])*(255-bgr2[2])/128;
            }
            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//亮光
- (Mat)VividLightWithBaseImage:(Mat)base blend:(Mat)blend
{

    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);


            if (bgr2[0] < 128)
            {
                if (bgr2[0] == 0)
                {
                    CGFloat r = 2*bgr2[0];
                    bgr3[0] = floor(r);
                }
                else
                {
                    CGFloat r = MAX(0, (255-((255-bgr1[0]) << 8) /(2*bgr2[0])));
                    bgr3[0] = floor(r);
                }
            }
            else
            {
                if (2*(bgr2[0]-128) == 255)
                {
                    CGFloat r = 2*(bgr2[0]-128);
                    bgr3[0] = r;
                }
                else
                {
                    CGFloat r = MIN(255, (bgr1[0] << 8) / (255- 2*(bgr2[0] - 128)));
                    bgr3[0] = r;
                }
            }



            if (bgr2[1] < 128)
            {
                if (bgr2[1] == 0)
                {
                    CGFloat g = 2*bgr2[1];
                    bgr3[1] = floor(g);
                }
                else
                {
                    CGFloat g = MAX(0, (255-((255-bgr1[1]) << 8) /(2*bgr2[1])));
                    bgr3[1] = floor(g);
                }
            }
            else
            {
                if (2*(bgr2[1]-128) == 255)
                {
                    CGFloat g = 2*(bgr2[1]-128);
                    bgr3[1] = g;
                }
                else
                {
                    CGFloat g = MIN(255, (bgr1[1] << 8) / (255- 2*(bgr2[1] - 128)));
                    bgr3[1] = g;
                }
            }


            if (bgr2[2] < 128)
            {
                if (bgr2[2] == 0)
                {
                    CGFloat b = 2*bgr2[2];
                    bgr3[2] = floor(b);
                }
                else
                {
                    CGFloat b = MAX(0, (255-((255-bgr1[2]) << 8) /(2*bgr2[2])));
                    bgr3[2] = floor(b);
                }
            }
            else
            {
                if (2*(bgr2[2]-128) == 255)
                {
                    CGFloat b = 2*(bgr2[2]-128);
                    bgr3[2] = b;
                }
                else
                {
                    CGFloat b = MIN(255, (bgr1[2] << 8) / (255- 2*(bgr2[2] - 128)));
                    bgr3[2] = b;
                }
            }

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//线性光
- (Mat)LinearLightWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MIN(255, MAX(0, bgr1[0] + 2*bgr2[0] - 255));

            bgr3[1] = MIN(255, MAX(0, bgr1[1] + 2*bgr2[1] - 255));

            bgr3[2] = MIN(255, MAX(0, bgr1[2] + 2*bgr2[2] - 255));

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//点光
- (Mat)PinLightWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MAX(0, MAX(2*bgr2[0]-255, MIN(bgr1[0], 2*bgr2[0])));

            bgr3[1] = MAX(0, MAX(2*bgr2[1]-255, MIN(bgr1[1], 2*bgr2[1])));

            bgr3[2] = MAX(0, MAX(2*bgr2[2]-255, MIN(bgr1[2], 2*bgr2[2])));

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//实色混合模式
- (Mat)HardMixWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            if (bgr1[0]+bgr2[0]>= 255) {
                bgr3[0] = 255;
            } else {
                bgr3[0] = 0;
            }

            if (bgr1[1]+bgr2[1]>= 255) {
                bgr3[1] = 255;
            } else {
                bgr3[1] = 0;
            }

            if (bgr1[2]+bgr2[2]>= 255) {
                bgr3[2] = 255;
            } else {
                bgr3[2] = 0;
            }

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//差值
- (Mat)DifferenceWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = abs(bgr1[0]-bgr2[0]);

            bgr3[1] = abs(bgr1[1]-bgr2[1]);

            bgr3[2] = abs(bgr1[2]-bgr2[2]);

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//排除
- (Mat)ExclusionWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MIN(255, MAX(0, bgr1[0] + bgr2[0] - bgr1[0]*bgr2[0]/128));

            bgr3[1] = MIN(255, MAX(0, bgr1[1] + bgr2[1] - bgr1[1]*bgr2[1]/128));

            bgr3[2] = MIN(255, MAX(0, bgr1[2] + bgr2[2] - bgr1[2]*bgr2[2]/128));

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//减去
- (Mat)SubtractWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            bgr3[0] = MAX(0, bgr1[0] - bgr2[0]);

            bgr3[1] = MAX(0, bgr1[1] - bgr2[1]);

            bgr3[2] = MAX(0, bgr1[2] - bgr2[2]);

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

//划分
- (Mat)DivideWithBaseImage:(Mat)base blend:(Mat)blend
{
    Mat mix(base.rows, base.cols, CV_8UC4);
    for (int i = 0; i < base.rows; i++) {
        for (int j = 0; j < base.cols; j++) {
            Vec4b bgr1 = base.at<Vec4b>(i, j);
            Vec4b bgr2 = blend.at<Vec4b>(i, j);
            Vec4b bgr3 = mix.at<Vec4b>(i, j);

            
            CGFloat r = bgr1[0]*256/(bgr2[0]+1);
            bgr3[0] = floor(r);

            CGFloat g = bgr1[1]*256/(bgr2[1]+1);
            bgr3[1] = floor(g);

            CGFloat b = bgr1[2]*256/(bgr2[2]+1);
            bgr3[2] = floor(b);

            [self check:bgr3];

            bgr3[3] = 255;
            mix.at<Vec4b>(cv::Point(j, i)) = bgr3;
        }
    }
    return mix;
}

- (void)check:(Vec4b)v
{
    if (v[0] < 0 || v[0] > 255 || v[1] < 0 || v[1] > 255 || v[2] < 0 || v[2] > 255)
    {
        NSLog(@"+++++++");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
