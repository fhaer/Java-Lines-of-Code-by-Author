#!/usr/bin/perl
# recursive search for java files; counts lines of code (loc) for each @author and loc for all authors; calculates loc share for each @author; one author tag may contain multiple authors separated by .;&.
my %loc = ();
countdir(".");
print "\n";
printf("%20s %7d %.2f\n", $_, $loc{$_}, $loc{$_}/$loc{"all"}) foreach (keys %loc);

sub countdir {
 my $d = shift;
 opendir D, $d or die;
 my @l = readdir D;
 closedir D;
 foreach (@l) {
  my $f = "$d/$_";
  if (-d $f && $_ ne "." && $_ ne "..") {
   countdir($f);
  } elsif (-f $f && $f =~ /\.java$/i) {
   my $floc = 0;
   my @authors = ("all");
   open F, $f or die;
   while (<F>) {
    $floc++ if (/\s*\w+.*;/);
    my $a = $1 if (/\@author\s+(.+?)\s*\r?\n/);
    my @a = split(/[,;&.]/, $a);
    $_ =~ s/\W+//g foreach (@a);
    push(@authors, $_) foreach (@a);    
   } 
   $loc{$_} += $floc foreach (@authors);
   close F;
   printf("%5d %10s\n", $floc, $f);
  }
 }
}
