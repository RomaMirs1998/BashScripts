# Creating Thumbnails for Morse-Code Enthusiasts

As a morse-code enthusiast, it's a joy to share the passion for morse code with others. One way to do this is through a web page, adorned with images of morse keys. This script, thumbnails.sh, is designed to help you prepare those images by creating thumbnails, allowing for faster page loads and a better user experience.
Table of Contents

- Description
- Usage
- Options
- Examples
- Prerequisites
   

## Description

The thumbnails.sh script takes image files as arguments and automatically creates thumbnails of a specified size. It leverages the identify and convert tools from the well-known imagemagick package.
Usage

```bash

./thumbnails.sh (-e|-p|-s) [-d] dimension image [...]

```

## Options

    -e: Creates exact thumbnails. This does not maintain the original image proportions, stretching the image to d×dd×d.
    -p: Creates proportional thumbnails, scaling the image proportionally. The longer dimension (x or y) is scaled to the given dimension dd.
    -s: Creates square thumbnails without stretching. This scales the shorter dimension (x or y) to dd, then crops the rectangle to d×dd×d.
    -d: Additionally deletes EXIF metadata from thumbnails for web publishing. This can be essential for privacy when publishing images online.

dimension: Specifies the thumbnail size (e.g., 300px).
## Examples

To create exact thumbnails of size 300px:

```bash

./thumbnails.sh -e 300px image1.jpg image2.jpg
```

To create proportional thumbnails of size 400px and delete EXIF data:

```bash

./thumbnails.sh -p -d 400px image1.jpg image2.jpg
```

To create square thumbnails of size 500px:

```bash

./thumbnails.sh -s 500px image1.jpg image2.jpg
```
## Prerequisites

Ensure you have the imagemagick package installed, as this script relies on identify and convert tools from it.