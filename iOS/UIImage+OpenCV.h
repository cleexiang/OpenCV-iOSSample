//
//  UIImage+OpenCV.h
//  iOS
//
//  Created by clee on 16/3/16.
//  Copyright © 2016年 cleexiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface UIImage (OpenCV)

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@end