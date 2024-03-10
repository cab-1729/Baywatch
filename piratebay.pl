#!/bin/perl
#TODO: make it work under tor
#TODO: fix alignment of categories shown first time
use strict;
use warnings;
use HTTP::Tiny;
use URI::Encode 'uri_encode';
use HTML::Entities 'decode_entities';
use JSON::Parse 'parse_json';
use Term::ReadKey qw(ReadKey ReadMode);
use Term::ANSIColor qw(CLEAR BOLD UNDERLINE ITALIC MAGENTA BRIGHT_MAGENTA BRIGHT_YELLOW BRIGHT_BLUE CYAN BRIGHT_CYAN BRIGHT_GREEN BRIGHT_RED BRIGHT_WHITE BRIGHT_BLACK ON_BRIGHT_WHITE);
use Number::Format 'format_bytes';
use Clipboard;
use Switch;
my $internet=HTTP::Tiny->new;
my %categories=(
	101=>"Audio>Music",
	102=>"Audio>Audio book",
	103=>"Audio>Sound clip",
	104=>"Audio>FLAC",
	199=>"Audio>Other",
	201=>"Video>Movies",
	202=>"Video>Movies DVD",
	203=>"Video>Music video",
	204=>"Video>Movie clip",
	205=>"Video>TV show",
	206=>"Video>Handheld",
	207=>"Video>HD Movies",
	208=>"Video>HD TV shows",
	209=>"Video>3D",
	299=>"Video>Other",
	301=>"Applications>Windows",
	302=>"Applications>Mac",
	303=>"Applications>UNIX",
	304=>"Applications>Handheld",
	305=>"Applications>IOS",
	306=>"Applications>Android",
	399=>"Applications>Other OS",
	401=>"Games>PC",
	402=>"Games>Mac",
	403=>"Games>PSx",
	404=>"Games>XBOX360",
	405=>"Games>Wii",
	406=>"Games>Handheld",
	407=>"Games>IOS",
	408=>"Games>Android",
	499=>"Games>Other",
	501=>"Porn>Movies",
	502=>"Porn>Movies DVD",
	503=>"Porn>Pictures",
	504=>"Porn>Games",
	505=>"Porn>HD Movies",
	506=>"Porn>Movie clip",
	599=>"Porn>Other",
	601=>"Other>E-book",
	602=>"Other>Comics",
	603=>"Other>Pictures",
	604=>"Other>Covers",
	605=>"Other>Physibles",
	699=>"Other>Other",
);
for(;;){
	my $cats='   ';
	print CLEAR,BRIGHT_YELLOW,"Audio: ",BRIGHT_GREEN,"✔️\t",BRIGHT_YELLOW,"Video: ",BRIGHT_GREEN,"✔️\t",BRIGHT_YELLOW,"Applications: ",BRIGHT_GREEN,"✔️\n",BRIGHT_YELLOW,"Games: ",BRIGHT_GREEN,"✔️\t",BRIGHT_YELLOW,"Porn: ",BRIGHT_GREEN,"✔️\t",BRIGHT_YELLOW,"Other: ",BRIGHT_GREEN,"✔️\n",CLEAR,"Pirate Search : ";
	my $search=<STDIN>;
	while($search=~/^\s*$/){#blank search, indicating user wants to change settings
		$cats='';
		ReadMode 'cbreak';
		my $prompt;
		print BRIGHT_YELLOW,"Audio: ",BRIGHT_GREEN;
		$prompt=1;
		do{
			switch(ReadKey 0){
				case 'y'{
					$cats.='%2C100';
					print "✔️\t";
					$prompt=0;
				}
				case 'n'{
					print "❌\t";
					$prompt=0;
				}
			}
		}while($prompt);
		print BRIGHT_YELLOW,"Video: ",BRIGHT_GREEN;
		$prompt=1;
		do{
			switch(ReadKey 0){
				case 'y'{
					$cats.='%2C200';
					print "✔️\t";
					$prompt=0;
				}
				case 'n'{
					print "❌\t";
					$prompt=0;
				}
			}
		}while($prompt);
		print BRIGHT_YELLOW,"Applications: ",BRIGHT_GREEN;
		$prompt=1;
		do{
			switch(ReadKey 0){
				case 'y'{
					$cats.='%2C300';
					print "✔️\n";
					$prompt=0;
				}
				case 'n'{
					print "❌\n";
					$prompt=0;
				}
			}
		}while($prompt);
		print BRIGHT_YELLOW,"Games: ",BRIGHT_GREEN;
		$prompt=1;
		do{
			switch(ReadKey 0){
				case 'y'{
					$cats.='%2C400';
					print "✔️\t";
					$prompt=0;
				}
				case 'n'{
					print "❌\t";
					$prompt=0;
				}
			}
		}while($prompt);
		print BRIGHT_YELLOW,"Porn: ",BRIGHT_GREEN;
		$prompt=1;
		do{
			switch(ReadKey 0){
				case 'y'{
					$cats.='%2C500';
					print "✔️\t";
					$prompt=0;
				}
				case 'n'{
					print "❌\t";
					$prompt=0;
				}
			}
		}while($prompt);
		print BRIGHT_YELLOW,"Other: ",BRIGHT_GREEN;
		$prompt=1;
		do{
			switch(ReadKey 0){
				case 'y'{
					$cats.='%2C600';
					print "✔️\n";
					$prompt=0;
				}
				case 'n'{
					print "❌\n";
					$prompt=0;
				}
			}
		}while($prompt);
		ReadMode 'normal';
		print CLEAR,"Pirate Search : ";
		$search=<STDIN>;
	}
	my $search_results=parse_json $internet->get('https://apibay.org/q.php?q='.uri_encode($search)."&cat=".substr $cats,3)->{content};
	if($search_results->[0]->{'id'}==0){
		print "Nothing found.\n";
		redo;
	}
	my @items=();
	#Not showing username and number of files
	my ($category_width,$name_width,$size_width,$seeder_width,$leecher_width)=(0,0,0,0,0);
	foreach my $item (@{$search_results}){#counting spaces for alignment
		my $length;
		my $category=$categories{$item->{'category'}};
		$length=length($category);
		if($length>$category_width){$category_width=$length;}
		my $name=$item->{'name'};
		$length=length($name);
		if($length>$name_width){$name_width=$length;}
		my $size=format_bytes($item->{'size'});
		$length=length($size);
		if($length>$size_width){$size_width=$length;}
		my $seeders=$item->{'seeders'};
		$length=length($seeders);
		if($length>$seeder_width){$seeder_width=$length;}
		my $leechers=$item->{'leechers'};
		$length=length($leechers);
		if($length>$leecher_width){$leecher_width=$length;}
		unshift(@items,[$category,$name,$size,$seeders,$leechers])
	}
	my $no_results=$#$search_results;
	my $num_width=2;
	if ($no_results<10){$num_width=1;}#api returns atmost 100 results
	foreach my $item (@items){#display results
		#numbers right aligned, text left aligned
		print MAGENTA,' 'x($num_width-($no_results<10?1:2)),"$no_results ",BRIGHT_MAGENTA,$item->[0],' 'x($category_width+1-length($item->[0])),BRIGHT_YELLOW,$item->[1],' 'x($name_width+1-length($item->[1])),BRIGHT_CYAN,' 'x($size_width-length($item->[2])),"$item->[2] ",BRIGHT_GREEN,' 'x($seeder_width-length($item->[3])),"$item->[3] ",BRIGHT_RED,' 'x($leecher_width-length($item->[4])),"$item->[4] ","\n";
		$no_results--;
	}
	for(;;){
		print CLEAR,'====> ';
		my $input=<STDIN>;#ask for torrent number
		if($input=~/^\s*$/){#only whitespaces in input
			last;;
		}
		my $number=int($input);
		my $description=decode_entities(parse_json($internet->get("https://apibay.org/t.php?id=".$search_results->[$number]->{'id'})->{content})->{'descr'});
		my $item=$items[$#items-$number];
		my $torrent_name=$item->[1];
		my $search_item=$search_results->[$number];
		print BRIGHT_MAGENTA,$item->[0],"\n\t",BOLD,BRIGHT_YELLOW,$torrent_name,CLEAR," by ",BRIGHT_BLUE,"$search_item->{'username'}",CYAN,"\n\t📁 $search_item->{'num_files'} ",BRIGHT_CYAN,"💽 $item->[2] ",BRIGHT_GREEN,"⬆️ $item->[3] ",BRIGHT_RED,"⬇️ $item->[4]";#display information
		ReadMode 'cbreak';
		my $prompt=1;
		my $magnet_link="magnet:?xt=urn:btih:".$search_item->{'info_hash'}."&dn=".uri_encode($torrent_name)."&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2710%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2780%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2730%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=http%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce";
		print CLEAR,"\n\nPress:\n\t",BRIGHT_BLACK,ON_BRIGHT_WHITE,BOLD,"d",CLEAR," to view description\n\t",BRIGHT_BLACK,ON_BRIGHT_WHITE,BOLD,"v",CLEAR," to view magnet link\n\t",BRIGHT_BLACK,ON_BRIGHT_WHITE,BOLD,"c",CLEAR," to copy magnet link to clipboard\n\t",BRIGHT_BLACK,ON_BRIGHT_WHITE,BOLD,"t",CLEAR," to send to transmission-client\n\t",BRIGHT_BLACK,ON_BRIGHT_WHITE,BOLD,"b",CLEAR," to go back\n";#menu
		do{
			switch(ReadKey 0){
				case "d" {
					print "\n",ITALIC,BRIGHT_WHITE,$description,CLEAR,"\n\n";
				}
				case "v" {
					print "\n",UNDERLINE,BRIGHT_CYAN,$magnet_link,CLEAR,"\n\n";
				}
				case "c" {
					Clipboard->copy_to_all_selections($magnet_link);
					print BRIGHT_GREEN,"Copied magnet link to clipboard!\n",CLEAR;
				}
				case "t" {
					print BRIGHT_GREEN;#to color both outpur of terminal command and messagBRIGHT_GREEN,e
					print (system("transmission-remote -a \"$magnet_link\"")==0?"Send to tranmission-cli\n":"Failed to send to tranmssion-cli\n");
					print CLEAR;
				}
				case "b" {
					$prompt=0;
				}
			}
		}while($prompt);
		ReadMode 'normal'
	}
}
