#!/usr/bin/perl -w

###################################################################
#-this programe is used to filter snp from all_codom
#2014.3.31
###################################################################
my $num   =80  ;
my $maf   =0   ;
my $mgr   =0   ;
my $msn   =27  ; 
my $cnt   =0   ;
my $print      ;
my @print      ;
my $ref        ;
my $input ="./genotype/all_codom";
my $output="./genotype/filter_all_codom";
parse_command_line();
open FIG,"<$input";
open OUT,">$output";
while(<FIG>){          
             my $sg         ;
             my $i          ;
             my $j          ;
             my $fir        ;
             my $sec        ;
             my @fir     =();
             my @sec     =();
             my @geno    =();
             my %base    =();
             chomp;
             $cnt++;
             @_=split(/\s+/);
             for($i=4;$i<$num+4;$i++){
                   $fir=substr($_[$i],0,1);
                   $sec=substr($_[$i],1,1);
                   push(@fir,$fir);
                   push(@sec,$sec);
                   if($fir ne "-" && $sec ne "-")
                   {$base{$fir}++;$base{$sec}++;} 
             }
             my @base;
             my $af  ;
             @base=sort {$base{$b}<=>$base{$a}} keys %base;      
             if(@base>1){
                   $af=$base{$base[1]}/($num*2);
                   for($i=0;$i<$num;$i++){
                         if(($fir[$i]eq$base[0] || $fir[$i]eq$base[1]) && ($sec[$i]eq$base[0] || $sec[$i]eq$base[1]))
                         {$sg++;}
                         else{$fir[$i]="-";$sec[$i]="-";}
                         $geno[$i]="$fir[$i]"."$sec[$i]";
                   }
                   $sgr=$sg/$num;
                   if($sgr>=$mgr && $af>=$maf){
                         $print="$_[0] "."$_[1] "."$_[2] "."$_[3] "."@geno"."\n";
                         if($cnt eq 1){
                               my $ref=$_[0];
                               push(@print,$print);
                         }
                         elsif($_[0] eq $ref){push(@print,$print);}
                         else{
                              if(@print<$msn){ 
                                    for($j=0;$j<@print;$j++)
                                    {print OUT "$print[$j]";}
                              }
                              else{;}
                              $ref=$_[0];@print=();
                              push(@print,$print);
                         }
                  }
             }
}

sub parse_command_line {
    if(!@ARGV){usage();} 
    while (@ARGV) {
	$_ = shift @ARGV;
	if    ($_=~/^-n$/) { $num   = shift @ARGV; }
        elsif ($_=~/^-i$/) { $input = shift @ARGV; }
        elsif ($_=~/^-o$/) { $output= shift @ARGV; }
        elsif ($_=~/^-m$/) { $maf   = shift @ARGV; }
        elsif ($_=~/^-g$/) { $mgr   = shift @ARGV; }
        elsif ($_=~/^-s$/) { $msn= shift @ARGV; }
	else               {
               print STDERR "Unknown command line option: '$_'\n";
	       usage();
	}
    }
}

sub usage {
    print STDERR <<EOQ; 
    perl filter-all_codom.pl -n -m -g -s -i -o [-h]
    n :num of individual                       [80]
    m :minor allele frequency                  [0]
    g :minor genotype rate                     [0]
    s :max SNP num in a tag                    [27]
    i :input file name                         [./genotype/all_codom]
    o :output file name                        [./genotype/filter_all_codom]
    h :display the help information.
    @@---------------------------------------------------------------------------------------@
    |                                 format of all_codom                                  |
    |                                                                                      |
    | >scaffold7-CTCC-2-19062 CTAACAAGCACTCTGTCTCCCTCTTCT 1 C CC CC CC CC CC CC CC CC CT   |
    | >scaffold7-CTCC-2-19062 CTAACAAGCACTCTGTCTCCCTCTTCT 15 G GG GG GG GG GG GG GG GG GG  |
    | >scaffold11-CTCC-1-14223 CTCTTCACTACTGGAGCTCCATTTGAA 15 A -- -- -- -- AA AC -- AA -- |
    @@---------------------------------------------------------------------------------------@

EOQ
exit(0);
}
