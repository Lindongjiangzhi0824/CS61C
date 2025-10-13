/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename,"r");
	// 分配 Image 结构体
	Image* img = (Image *)malloc(sizeof(Image));
	
	// char buff[256];
	char type[20];
	
	// 读取并解析文件头信息
	fscanf(fp, "%s", type);
	fscanf(fp, "%u %u",&img->cols,&img->rows);

	int size;
	fscanf(fp,"%d",&size);
	// 创建对于大小的 Image, 为行指针数组分配内存
	img->image = (Color **)malloc(img->rows * sizeof(Color *));
	// 为每行像素数据分配内存
	for(int i = 0; i < img->cols; i++){
		img->image[i] = (Color *)malloc(img->cols * sizeof(Color));
	}

	// RGB
	for (int i = 0; i < img->rows; i++)
	{
		for (int j = 0; j < img->cols; j++)
		{
			fscanf(fp, "%hhu %hhu %hhu", &img->image[i][j].R,  &img->image[i][j].G,  &img->image[i][j].B);
		}
		
	}
	fclose(fp);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n"); // 第一行
	int width = image->cols, height = image->rows;
	printf("%u %u\n",width,height); //第二行
	int color_range = 255;
	printf("%d\n",color_range);
	
	for(uint32_t  i = 0 ; i < width ; i++){
		for(uint32_t  j = 0 ; j < height; j++){
			if(j != 0){
				printf("   ");
			}
			printf("%3d ",image->image[i][j].R);
			printf("%3d ",image->image[i][j].G);
			printf("%3d",image->image[i][j].B);
		}
		printf("\n");
	}

}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for(int i = 0 ; i < image->rows ; i++){
		free(image->image[i]);
	}
	free(image->image);

	free(image);
}