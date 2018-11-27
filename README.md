# ArchiveMySQLBackups-Perl
The ArchiveMySQLBackups-Perl ( bsaf.pl ) was created to help automate the automatic archiving of MySQL Backups on a Linux Machine.  It will copy the *.sql files to a sub folder that is named after the current year and month, then after it copies all the files over, it will compress that directory into 1 tar file.
It was designed to run daily before the end of the day so if the year_month.tar.gz exists, then it will append to that file.

## Usage

All the settings that you need for this script will be stored at the first part of the script.

| Code | Description  |
|:--|:--|
| my $VERSION     = '1.0.01';  | Version of Script |
|  my $foldername  =""; | place holder |
| my $destdir     ="/shares/backups/MySQL/archived"; | Destination Directory |
| my $sourcedir   ="/shares/backups/MySQL/*.sql";  | Source Directory with File Extension |
| my $DEBUG       =0;   | Debug Mode (Display Messages) |
| my $MOVEONLY    =1;   | Enable Move Files |
| my $DOZIP       =1;   | Enable Zip compression on folder |
| my $DOCLEANUP   =1;  | Delete the year_month folder after compressing |
| my $DestDirFinal="";  | place holder |
| my $ZipDest     =""; | place holder |

Set the *$destdir* to the directory that you want to store the archive files.  Then use the *$sourcedir*  to set the location of the backup files.

the *$DEBUG* is optional if you want messages outputted to the screen.

If you are testing, then toggling the ability to move the files, zip them and then clean up the old files might interest you. 
If so then use the $DOZIP, *$DOCLEANUP* and *$MOVEONLY* switches accordingly.

After you have everything set the way you want it, then run the script. If it is to your liking, then add it in a cron job.
