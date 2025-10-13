/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	uint32_t val = image->image[row][col].B;
	// 确定最后一位是 0 还是 1
	int res = val & 1;
	Color *color = (Color *)malloc(sizeof(Color));
	if(res == 1){
		color->R = 255;
		color->G = 255;
		color->B = 255;
	}else{
		color->R = 0;
		color->G = 0;
		color->B = 0;
	}
	return color;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	int cols,rows;
	cols = image->cols;
	rows = image->rows;
	// 分配地址空间
	Image* newImage = (Image*)malloc(sizeof(Image));
	newImage->rows = rows;
	newImage->cols = cols;

	newImage->image = (Color**)malloc(rows * sizeof(Color*));
	for(int i = 0 ; i < rows; i++){
		newImage->image[i] = (Color*)malloc(cols * sizeof(Color));
	}

	// 给新 image 赋值
	for(int i = 0 ; i < rows ; i++){
		for(int j = 0 ; j < cols; j++){
			newImage->image[i][j] = *(evaluateOnePixel(image,i,j));
			free(evaluateOnePixel(image,i,j));
		}
	}

	return newImage;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	// char **argv = char *argv[] 相当每个参数都是一个指针
	// argv[0] 程序名字符串  argv[1] 第一个参数字符串
	if(argc <= 1){
		return -1;
	}
	char* file_name = argv[1];
	Image* image = readData(file_name);
	Image* new_image = steganography(image);
	writeData(new_image);
	freeImage(image);
	freeImage(new_image);

	return 0;
}
