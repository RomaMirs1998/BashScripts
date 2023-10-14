# Automatic Image Downloader for Morse Keys and Paddles

Morse code, as detailed in Wikipedia, has brought about a significant revolution in tele-communication during the 19th century. This tool allows Morse code enthusiasts to automatically download images of historic morse keys and paddles from the Wikimedia Commons.
Description

This shell script, named imgdownloader.sh, is designed to:

    Download the HTML page of a specified Wikimedia Commons Link.
    Parse the HTML code to extract the image URLs.
    Iteratively download and store all the high-resolution images in a specified folder.

 ## Usage

To use the script:

```css

./imgdownloader.sh [WIKIMEDIA_COMMONS_URL] [TARGET_FOLDER]
```
Replace:

    [WIKIMEDIA_COMMONS_URL] with the actual Wikimedia Commons page URL, e.g., https://commons.wikimedia.org/wiki/Category:Straight_keys
    [TARGET_FOLDER] with the directory where you want the images to be saved.

## Prerequisites

Ensure the following tools are installed:

    wget or curl for downloading web content.
    grep, sed, or other text processing utilities if they are used in the script.

Make the script executable:

```bash

chmod +x imgdownloader.sh
```