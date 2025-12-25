/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

enum { N_NEIGHBORS = 8 };

Color evaluateOneCell(Image* image, int row, int col, uint32_t rule) {
	uint32_t upper_row = row == 0 ? image->rows - 1 : row - 1;
	uint32_t lower_row = row == image->rows - 1 ? 0 : row + 1;
	uint32_t left_col = col == 0 ? image->cols - 1 : col - 1;
	uint32_t right_col = col == image->cols - 1 ? 0 : col + 1;

	Color neighbors[N_NEIGHBORS] = {image->image[row][left_col],
		image->image[row][right_col],
		image->image[upper_row][col],
		image->image[lower_row][col],
		image->image[upper_row][left_col],
		image->image[upper_row][right_col],
		image->image[lower_row][left_col],
		image->image[lower_row][right_col]};

	uint8_t n_alive_neighbors = 0;
	for (uint8_t i = 0; i < N_NEIGHBORS; ++i) {
		if (neighbors[i].R != 0) {
			++n_alive_neighbors;
		}
	}

	bool cell_alive = image->image[row][col].R != 0;

	// Rule lookup:
	// bits 0–8  → dead cell with N neighbors
	// bits 9–17 → alive cell with N neighbors
	uint8_t bit_index = cell_alive ? (9 + n_alive_neighbors) : n_alive_neighbors;
	bool next_alive = (rule >> bit_index) & 1;

	Color result;
	result.R = result.G = result.B = next_alive ? 255 : 0;
	return result;
}

Image* life(Image* image, uint32_t rule) {
	Image* new_image = malloc(sizeof(Image));
	new_image->cols = image->cols;
	new_image->rows = image->rows;
	new_image->image = malloc(image->rows * sizeof(Color*));
	for (int i = 0; i < image->rows; ++i) {
		new_image->image[i] = malloc(image->cols * sizeof(Color));

		for (int j = 0; j < image->cols; ++j) {
			new_image->image[i][j] = evaluateOneCell(image, i, j, rule);
		}
	}
	return new_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then
prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this
will be a string. You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you
should exit with code -1. Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char** argv) {
	uint32_t rule = strtol(argv[2], NULL, 16);
	Image* image = readData(argv[1]);
	Image* transformed_image = life(image, rule);
	writeData(transformed_image);
	freeImage(image);
	freeImage(transformed_image);
	return 0;
}
