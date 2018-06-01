# Target Enrichment
Scripts and protocols for target enrichment. 

<h2>Sequence capture pipeline</h2>
<br>
The scripts used in [Unruh et al. 2018](https://onlinelibrary.wiley.com/doi/abs/10.1002/ajb2.1047) are described here. 

<h3>Splitting Alignments by Exons</h3>
<br>
Prior to running this script, you will need to have a file with exon information in this format:
	
	Phalaenopsis-equestris.PEQU_41130       exon0   0       113
	Phalaenopsis-equestris.PEQU_41130       exon1   114     509
	Phalaenopsis-equestris.PEQU_31751       exon0   0       224
	Phalaenopsis-equestris.PEQU_17327       exon0   0       122
	Phalaenopsis-equestris.PEQU_17327       exon1   123     361
	Phalaenopsis-equestris.PEQU_17327       exon2   362     536
	Phalaenopsis-equestris.PEQU_17327       exon3   537     820
	Phalaenopsis-equestris.PEQU_17327       exon4   821     893
	
You will also need a directory with alignments in them. The script expects the alignments to end in *.fsa.  

Commands for running the script:

	perl split_alignments_by_exons.pl Exon_file Alignment_Directory
	
Split exons alignment files will be created in the given directory using the naming format: OriginalFileName_exon_ExonPosition.fsa.
