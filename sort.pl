#!/usr/bin/perl -w
$genemap="./AJgene_in_genome";
parse_command_line();
open FIG,"<$map";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   if($_[0] ne $lg){$s=0;}
   else{;}
   $lg=$_[0];
   $lg{$_[-2]}=$_[0];
   $s{$_[-2]}=$s;
   $e{$_[-2]}=$s+$_[-1];
   $s=$e{$_[-2]};
}
close FIG;

open FIG,"<$genemap";
while(<FIG>){
   chomp;
   @_=split(/\s+/);
   $lg{$_[0]}=$_[2];
   $pos{$_[0]}=($_[-1]+$_[-2])/2;
}
close FIG;

if($type=~/reseqplink/){
   open FIG,"<$input";
   open OUT,">$input.sorted";
   open UNMAP,">$input.unsorted";
   print OUT "SNP\tCHR\tBP\tP\n";
   while(<FIG>){
      chomp;
      @_=split(/\s+|-/);
      @temp=split(/\s+/);
      $sca=$_[2];
      if(exists $lg{"$sca"}){
         $site=$s{$sca}+$_[3];
         print OUT "$temp[2]\t$lg{$sca}\t$site\t$temp[-2]\n";
      }
      else{print UNMAP "$_\n";}
   } 
   close FIG;
   close OUT;
}

if($type=~/2bplink/){
   open FIG,"<$input";
   open OUT,">$input.sorted";
   open UNMAP,">$input.unsorted";
   print OUT "SNP\tCHR\tBP\tP\n";
   while(<FIG>){
      chomp;
      @_=split(/\s+|-/);
      @temp=split(/\s+/);
      if($_[2]=~/unmap/||$_[2]=~/hete/){$sca=$_[2];}
      else{$sca="scaffold"."$_[2]";}
      if(exists $lg{"$sca"}){
         $site=$s{$sca}+$_[4]+$_[5];
         print OUT "$temp[2]\t$lg{$sca}\t$site\t$temp[-2]\n";
      }
      else{print UNMAP "$_\n";}
   } 
   close FIG;
   close OUT;
}

if($type=~/edgeR/){
   open FIG,"<$input";
   open OUT,">$input.sorted";
   open UNMAP,">$input.unsorted";
   print OUT "SNP\tCHR\tBP\tP\n";
   while(<FIG>){
      chomp;
      @_=split(/\s+|-/);
      @temp=split(/\s+/);
      $sca=$_[0];
      if(exists $lg{"$sca"}){
         $site=$pos{$sca};
         print OUT "$temp[0]\t$lg{$sca}\t$site\t$temp[-2]\n";
      }
      else{print UNMAP "$_\n";}
   } 
   close FIG;
   close OUT;
}

sub parse_command_line {
    if(!@ARGV){usage();} 
    while (@ARGV) {
        $_ = shift @ARGV;
        if    ($_=~/^-t$/) { $type   = shift @ARGV; }
        elsif ($_=~/^-i$/) { $input = shift @ARGV; }
        elsif ($_=~/^-m$/) { $map = shift @ARGV; }
        elsif ($_=~/^-gm$/) { $genemap = shift @ARGV; }
        else               {
               print STDERR "Unknown command line option: '$_'\n";
               usage();
        }
    }
}
sub usage {
    print STDERR <<EOQ; 
    perl sort.pl -i -t [-h]
    i :input file
    t :2bplink, edgeR or reseqplink 
    m :map-final
    gm:gene in genome
    h :display the help information.
EOQ
    exit(0);
}

