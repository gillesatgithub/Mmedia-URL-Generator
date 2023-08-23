use Mediainfo;
use URI::Encode;
use URI::Escape;
use Cwd qw(cwd);
use warnings FATAL => 'all';

my $dir = cwd;
my $MInfo = new Mediainfo("filename" => $ARGV[0]);
my $uri = URI::Encode->new( { encode_reserved => 0 } );

my $fpathname = $MInfo->{filename};
my $encoded = uri_escape($fpathname);

my $section = $ARGV[1];
my $basehtml = $ARGV[2];
my $srvrinfo = $ARGV[3];

my $prefix_url = $srvrinfo . "/" . $section . "/";
my $full_url = $prefix_url.$encoded;

my $milliseconds = $MInfo->{length};
my $seconds = int(($milliseconds / 1000) % 60) ;
my $minutes = int(($milliseconds / (1000*60)) % 60);
my $hours   = int(($milliseconds / (1000*60*60)) % 24);

if (int($hours) == 0) {
	printf("<tr bgcolor=#ddddff><td>%02dm%02d</td>", int($minutes), int($seconds));
} else {
	printf("<tr bgcolor=#ddddff><td>%02dh%02d</td>", int($hours), int($minutes));
}

print "<td>", $MInfo->{width}, "x", $MInfo->{height}, "</td>";
print "<td><a href=\"".$full_url."\">", $fpathname, "</a></td>";
printf("<td>%d</td>", $milliseconds);

(my $vttpath = $fpathname) =~ s/.mp4/.vtt/;

# Does the substitution took place
if ($vttpath ne $fpathname) {
	# both filename are not equal
	print STDERR "\e[38;5;9m" . $vttpath . " - " . $fpathname . "\e[0m\n";
	# Does the file existe with a vtt extension
	if (-e $vttpath) {
		# vtt filename exist
		#		print "<td>sub</td></tr>\n";
		# do the rest of the processing
		my $random_number = int(rand(100000));
		#		printf("<td>%05d</td></tr>\n",$random_number);
		printf("<td><a href=\"" . $srvrinfo . "/sub/" . $section . "/%d.html\">%d</a></td></tr>\n",$random_numb
er,$random_number);

		open my $fh, '>', "$basehtml" . "/sub/" . $section . "/" . $random_number . ".html";
		#		print {$fh} $random_number . ".html\n";
		#		print {$fh} $full_url . "\n" . uri_escape($vttpath) . "\n";
		my $uri_vttpath = uri_escape($vttpath);

print {$fh} "<html>\n<video id=\"video\" width=640 height=480 controls preload=\"metadata\">\n";
print {$fh} "		<source src=\"" . $full_url . "\"	type=\"video/mp4\">\n";
print {$fh} "		<track label=\"English\" kind=\"subtitles\" srclang=\"en\" src=\"" . $prefix_url . $uri_vttpath
 . "\"\n";
print {$fh} " default>\n";
print {$fh} "	Your browser does not support the video tag.\n";
print {$fh} "	</video>\n</html>\n";

		close $fh;

	} else {
		# vtt filename does not exist
		print STDERR "\e[38;5;10m" . $fpathname . "\e[0m\n";
		print "<td style=\"visibility:hidden;\">&nbsp;</td></tr>\n";
	}
} else {
	# both filename are equal
	print STDERR "\e[38;5;11m" . $fpathname . "\e[0m\n";
	print "<td style=\"visibility:hidden;\">&nbsp;</td></tr>\n";
}

printf STDERR "\e[0m";
