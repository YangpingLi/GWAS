#################################################################################
## transform all_codom to tped file                                            ##
## LiYangping 2014.12.5                                                        ##
#################################################################################
#!/usr/bin/env perl
parse_command_line();
open FIG,"<$input";
open TPED,">$output";
while(<FIG>){
             chomp;
             @_=split(/\s+/);
             @info=split(/>|-/,$_[0]);
             $sca=$info[1];
             $info[1]=~s/scaffold//;
             $snp="$info[1]"."-$info[2]"."-$info[3]"."-$_[2]";
             $base=$info[3];
             print TPED "$sca $snp 0 $base";
             for($i=6;$i<@_;$i++){
                                      $fir=substr($_[$i],0,1);
                                      $sec=substr($_[$i],1,1);
                                      print TPED " $fir $sec";
             }
             print TPED "\n";
}
close FIG;

sub parse_command_line {
  if(!@ARGV){usage();}
  else{
    while (@ARGV) {
	$_ = shift @ARGV;
	if       ($_ =~ /^-i$/)  { $input   = shift  @ARGV; }
        elsif    ($_ =~ /^-o$/)  { $output   = shift  @ARGV; }
        elsif    ($_ =~ /^-n$/)  { $num  = shift  @ARGV; }
        elsif    ($_ =~ /^-h$/) {usage();}
        else                     { 
                  print STDERR "Unknown command line option: '$_'\n";
	          usage();
        }
    }
 }
}
sub usage {
    print STDERR <<EOQ; 
    perl tped.pl -i -o -n [-h]
    i  : all_codom or filter_all_codom           
    o  : tped file
    n  : number of individual     
    h  : display the help information.
EOQ
exit(0);
}
