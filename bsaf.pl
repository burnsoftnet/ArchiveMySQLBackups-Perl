#!/usr/bin/perl
# ======================================================================
#
# Perl Source File -- Created with BurnSoft BurnPad
#
# NAME: <bsaf.pl>
#
# AUTHOR: BurnSoft www.burnsoft.net
# DATE  : 10/24/2008
#
# PURPOSE: This script was created to help audomate automatic archiving of
#         MySQL Backups on a Linux Machine.  It will copy the *.sql files
#         to a sub folder that is named after the current year and month,
#         then after it copies all the files it will compress that directory
#         into 1 file.  If was designed to run daily before the end of the day
#         so if the year_month.tar.gz exists, it will append to that file.
#	  BurnSoft Archive Files (bsaf)
#
# ======================================================================
use File::Path;
use Net::FTP;

my $VERSION     = '1.0.01';                       #Version of Script
my $foldername  ="";
my $destdir     ="/shares/backups/MySQL/archived"; #Destination Directory
my $sourcedir   ="/shares/backups/MySQL/*.sql";   #Source Directory with File Extension
my $DEBUG       =0;                               #Debug Mode (Display Messages)
my $MOVEONLY    =1;                               #Enable Move Files
my $DOZIP       =1;                               #Enable Zip compression on folder
my $DOCLEANUP   =1;                               #Delete the year_month folder after compressing
my $DestDirFinal="";
my $ZipDest     ="";

&GetDataFormat;
$DestDirFinal= "$destdir\/$foldername/";
$ZipDest= "$destdir\/$foldername.tar";
&ShowDebug("New Backup Directory is $DestDirFinal\n");
&ShowDebug("New Zipped Archived is $ZipDest\n");
if ($MOVEONLY) {
  &CreateDirectory;
  &MoveFiles;
}
if ($DOZIP) {
  &ZipDir;
  }
if ($DOCLEANUP) {
  &DeleteDirectory;
  }
# ======================================================================
sub GetDataFormat
{
  $date_time = localtime($^T);
  $vmonth = substr($date_time, 4, 3);
  $vyear = substr($date_time, 20, 4);
  $foldername = "$vyear\_$vmonth";
}
# ======================================================================
sub CreateDirectory
{
  my @created = mkpath($DestDirFinal,{verbose => 1, mode => 0750},);
  print "created $_\n" for @created;
}
# ======================================================================
sub DeleteDirectory
{
  rmtree( $DestDirFinal, {keep_root => 1} );
}
# ======================================================================
sub MoveFiles
{
  system("mv $sourcedir $DestDirFinal");
}
# ======================================================================
sub ZipDir
{
  if (-w "$ZipDest.gz")
  {
      &ShowDebug("File exist! Running gunzip\n");
      system("gunzip $ZipDest.gz");
      &ShowDebug("Appending extra files to current archive.\n");
      system("tar -uvf $ZipDest $DestDirFinal");
      #print "File does not exist!\n";
    }
    else {
      #print "File exist!\n";
      &ShowDebug("File does not exist!\n");
      &ShowDebug("Creating new archive.\n");
      system("tar -cvf $ZipDest $DestDirFinal");
  }
  system("gzip -f $ZipDest");
}
# ======================================================================
sub ShowDebug{
  ($msg) = @_;
  if ($DEBUG){
    print "DEBUG: $msg\n";
  }
}
# ======================================================================
