# Mmedia-URL-Generator
Multimedia URL Generator
Overview

The Multimedia URL Generator shell script is a tool designed to scan
a specified directory for multimedia files and generate an HTML file
containing URLs constructed based on user-provided base paths. This
script simplifies the process of creating a list of multimedia URLs
for web-based presentations, galleries, or any other use case where
multimedia files need to be accessible via URLs.

Features

Scans a directory for multimedia files (images, videos, audio files,
etc.).
Generates an HTML file containing URLs constructed with specified
base paths.
Supports customization of base paths for both data and HTML URLs.

Prerequisites

	Unix-like operating system (Linux, macOS).
	Bash shell (version 3.0+).
	Perl and following modules
		Mediainfo
		URI::Encode
		URI::Escape
		Cwd qw(cwd)
	Basic understanding of shell and Perl scripting.

	Lighttpd (or other web server)
	tablesort css in BASEHTML/sub

Usage

Clone the repository:

git clone https://github.com/yourusername/multimedia-url-generator.git
cd multimedia-url-generator

Edit the Configuration:

Open the generate_multimedia_urls.sh script in a text editor and modify the following variables:

BASEDATA: The base path of the directory containing multimedia files.
BASEHTML: The base URL path where multimedia files will be accessible.
BASEPRGM="<$HOME>/work"
SRVRINFO="<ip or name>/Media"

Run the Script:

Make the script executable and run it:

chmod +x generate_multimedia_urls.sh
./generate_multimedia_urls.sh

Output:

The script will generate an HTML file named multimedia_urls.html in the
given directory $BASEHTML. This HTML file will contain URLs for all
multimedia files found in the specified directory, constructed using
the provided base paths.

Example

Suppose you have the following configuration:

BASEDATA="/path/to/multimedia/files"
BASEHTML="https://example.com/multimedia/"

And your multimedia directory contains the following files:

/path/to/multimedia/files/
    image1.jpg
    video1.mp4
    audio1.mp3

Running the script will generate an multimedia_urls.html file with the following content:

<!DOCTYPE html>
<html>
<head>
    <title>Multimedia URLs</title>
</head>
<body>
    <ul>
        <li><a href="https://example.com/multimedia/video1.mkv>video1.mkv</a></li>
        <li><a href="https://example.com/multimedia/video2.mp4">video2.mp4</a></li>
        <li><a href="https://example.com/multimedia/video3.avi">video3.avi</a></li>
    </ul>
</body>
</html>

Notes

This script assumes that the multimedia files are publicly accessible
via the specified base HTML URL.
The generated HTML file can be customized further to suit your presentation needs.

Support

For any issues or suggestions, please create an issue on the GitHub repository.

Author

Created by gilles@votk.com
