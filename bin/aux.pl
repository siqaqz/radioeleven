#!/usr/bin/perl -w
use strict;
use bytes;
use Shout;
use MP3::Tag;
use Encode;

###############################################################################
###	C O N F I G U R A T I O N
###############################################################################
use vars qw{$Debug $Lame};
chomp( $Lame = `which lame` );
my $Bitrate = 128;
my $Samplerate = 44100;

### Create a new streaming object
my $streamer = new Shout
	host		=> 'xxxx.radio.co',
	port		=> xxxx,
	mount		=> '',
	password	=> 'xxxx',
	name		=> 'radio eleven',
	genre		=> 'my genre',
	description	=> 'my description',
	bitrate		=> $Bitrate,
	format		=> SHOUT_FORMAT_MP3,
	protocol	=> SHOUT_PROTOCOL_ICY;

$streamer->set_audio_info(SHOUT_AI_BITRATE => $Bitrate, SHOUT_AI_SAMPLERATE => $Samplerate);

###############################################################################
###	M A I N   P R O G R A M
###############################################################################

### Try to connect, aborting on failure
if ( $streamer->open ) {
	$streamer->set_metadata("song" => "LIVE");
} else {
	printf "couldn't connect: %s\n", $streamer->get_error;
	exit $streamer->get_errno;
}

  
  my ($buff, $len);
    while (($len = sysread(STDIN, $buff, 4096)) > 0) {
  unless ($streamer->send($buff)) {
      print "Error while sending: " . $streamer->get_error . "\n";
      last;
  }
  $streamer->sync;
    }
    $streamer->close;
