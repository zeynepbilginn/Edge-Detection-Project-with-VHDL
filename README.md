# VHDL Sobel Edge Detection Project

This project is developed for the Hardware Description Languages course and simulates a VHDL code that utilizes the Sobel filter to detect edges in a 256x256 pixel grayscale image. The project demonstrates the application of VHDL in image processing, specifically in edge detection using the Sobel operator.

## Project Overview

The VHDL system takes a grayscale image of 256x256 pixels as input and applies the Sobel filter to identify edges within the image. Each pixel is represented as 16 bits, and the image data is read from a file and written into a RAM block. This RAM block is organized in rows and columns, where a mask identifying edges is applied to the image. The output image, with edges extracted, is then written back to a file.

## Sobel Operator
<img src="https://homepages.inf.ed.ac.uk/rbf/HIPR2/figs/sobmasks.gif" width="500" height=auto alt="Image description">


The Sobel operator is a widely used edge detection algorithm in image processing and computer vision. It works by calculating the gradient of the image intensity at each pixel, identifying the edges within the image. The gradient measures the rate of change in brightness and is computed using two 3x3 convolution kernels, one for the horizontal changes (Gx) and one for the vertical changes (Gy).e.

<img src="https://homepages.inf.ed.ac.uk/rbf/HIPR2/figs/sobmasks.gif" width="500" height=auto alt="Image description">

The Sobel operator is a cornerstone of edge detection in image processing and computer vision. It identifies edges by calculating the gradient of image intensity at each pixel, thus highlighting regions of high spatial frequency that correspond to edges.

### How It Works

The Sobel operator uses two 3x3 convolution kernels to calculate the gradients in the horizontal (Gx) and vertical (Gy) directions. The kernels are applied to each pixel of the image to compute the gradient components for that pixel.



## Implementation Details

- **Data Preparation**: Image data is read from a file and loaded into a RAM block for processing.  
- **Edge Detection**: The Sobel filter is applied to the grayscale image within the RAM block, calculating the gradient magnitude and direction for each pixel.  
- **Output Generation**: The final image, showcasing the detected edges, is written to an output file for visualization.  

## How to Use

1. Ensure you have a VHDL simulator installed on your system.  
2. Clone this repository to your local machine.  
3. Load the VHDL file into your simulator.  
4. Run the simulation with the provided test image or your own 256x256 pixel grayscale image.  
5. Check the output file for the edge-detected image.  
