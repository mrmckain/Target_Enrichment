#!/usr/bin/perl -w
use strict;

my %exons;

open my $file, "<", $ARGV[0];
while(<$file>){
		chomp;

		my @tarray= split /\s+/;
		$tarray[1] =~ /exon(\d+)/;
		$tarray[1] = $1;

		$exons{$tarray[0]}{$tarray[1]}{START}=$tarray[2];
		$exons{$tarray[0]}{$tarray[1]}{END}=$tarray[3];

}


my @files = <$ARGV[1]/*.fsa>;
for my $file (@files){
		print "$file\n";
		open my $tfile, "<", $file;
		my $tempsid;
		my %tempalign;
		my %temp_position;
		while(<$tfile>){
			chomp;
			if(/>/){
				$tempsid=substr($_, 1);
			}
			elsif($tempsid){
				$tempalign{$tempsid}.=$_;
			}
		}
		for my $ids (keys %tempalign){
			if(exists $exons{$ids}){
				my $max_exon=0;
				my $min_exon=10000;
				for my $tex (keys %{$exons{$ids}}){
					if($tex > $max_exon){
						$max_exon=$tex;
					}
					if($tex < $min_exon){
						$min_exon=$tex;
					}
				}
				my $total_position=0;
				my $running_gene_position=0;
				my %split_gene;
				my @temp_split = split(//,$tempalign{$ids});
				for (my $i=0; $i<length($tempalign{$ids}); $i++){
					if($temp_split[$i] =~ /A|T|G|C/i){

						$split_gene{$running_gene_position}=$i;
						$running_gene_position++;
					}
				}
				for my $tempexons(sort {$a<=>$b} keys %{$exons{$ids}}){
					if($tempexons == 0){
						if($split_gene{$exons{$ids}{$tempexons}{START}} != 0){
							$temp_position{"-1"}{START}=0;
							$temp_position{"-1"}{END}=$split_gene{$exons{$ids}{$tempexons}{START}}-1;
						}
					}
					if($tempexons == $max_exon){
						if(!exists $split_gene{$exons{$ids}{$tempexons}{END}}){
							if(!exists $split_gene{$exons{$ids}{$tempexons}{START}}){
								next;
							}
							else{	
								$temp_position{$tempexons}{START}=$split_gene{$exons{$ids}{$tempexons}{START}};
								$temp_position{$tempexons}{END}=length($tempalign{$ids})-1;
							}
						}
						else{
				
							$temp_position{$tempexons}{START}=$split_gene{$exons{$ids}{$tempexons}{START}};
							$temp_position{$tempexons}{END}=$split_gene{$exons{$ids}{$tempexons}{END}};
						}
					}
					else{
						 $temp_position{$tempexons}{START}=$split_gene{$exons{$ids}{$tempexons}{START}};
                                                        $temp_position{$tempexons}{END}=$split_gene{$exons{$ids}{$tempexons}{END}};
					}
				}	
			}
		}
		unless(%temp_position){
			next;
		}
		for my $pos(sort {$a<=>$b} keys %temp_position){
			$file =~ /(.*?)\./;
			open my $tempout, ">", $1 . "_exon_" . $pos .".fsa";
			for my $ids (keys %tempalign){
			
				my $temp_seq = substr($tempalign{$ids}, $temp_position{$pos}{START}, ($temp_position{$pos}{END}-$temp_position{$pos}{START}+1));

				print $tempout ">$ids\n$temp_seq\n";
			}
		}
	}



