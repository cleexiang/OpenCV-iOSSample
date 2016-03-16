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

@interface BlendViewController ()

@property (nonatomic) UIImageView *orgImageView;
@property (nonatomic) UIImageView *mixedImageView;

@end

@implementation BlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIImage *orgImg = [UIImage imageNamed:@"demo.jpg"];
    self.orgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, orgImg.size.width, orgImg.size.height)];
    self.orgImageView.image = orgImg;
    [self.view addSubview:self.orgImageView];

    self.mixedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 400, orgImg.size.width, orgImg.size.height)];
    [self.view addSubview:self.mixedImageView];

    Mat baseMat = [UIImage cvMatFromUIImage:orgImg];
    orgImg = [UIImage imageNamed:@"blend.jpg"];
    Mat blendMat = [UIImage cvMatFromUIImage:orgImg];

    Mat mixMat = [self multiplyWithBaseImage:baseMat blend:blendMat];
    self.mixedImageView.image = [UIImage UIImageFromCVMat:mixMat];
}

- (Mat)darkenWithBaseImage:(Mat)base blend:(Mat)blend
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

- (Mat)multiplyWithBaseImage:(Mat)base blend:(Mat)blend
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
