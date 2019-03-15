# Guide to performing Approximate Bayesian Computation (ABC) using SNP data

Approximate Bayesian Computation (ABC) is a powerful statistical framework that can be used to estimate demographic parameters from large genomic data sets. In the past few years, many useful review papers have been published on ABC methods, so check out some of those papers for further details (See ‘ABC Resources’ section below). Briefly, a large number of simulations are performed, with parameters being drawn from a probability distribution. The simulated genetic data are then reduced to summary statistics. The choice of summary statistics to use in ABC is up to you, but many studies employing SNP data use the site frequency spectrum (SFS). Next, the simulated summary statistics are compared to the observed statistics and a metric of distance is calculated. The associated sampled parameters are then either accepted or rejected based on their distance metric, yielding parameters whose summary statistics most closely match those of the observed data. 

## Preparing the observed data:

First, I generated a joint SFS of my observed data using Arelquin (<http://cmpg.unibe.ch/software/arlequin35/>). You may need to format your data for Arlequin (*.arp file) before starting a Arlequin project to create the SFS. The Arlequin manual is [here](http://cmpg.unibe.ch/software/arlequin35/man/Arlequin35.pdf) and contains useful information on how to generate SFSs. The SFS output file(s) will have a '.obs' extension, for example 'PADEadults\_zeros\_jointMAFpop1_0.obs'.

### **An example observed joint SFS file (PADEadults\_zeros\_jointMAFpop1_0.obs)**:
	> head(obs) # observed joint SFS file of two populations containing 271 and 195 indivdiuals, respectively
	     d0_0 d0_1 d0_2 d0_3 d0_4 d0_5 d0_6 d0_7 d0_8 d0_9 d0_10 d0_11 d0_12 d0_13
	d1_0    0    0    0    0    0    0    0    0    0    0     0     0     0     0
	d1_1    0    0    0    0    0    0    0    0    0    0     0     0     0     0
	d1_2    0    0    0    0    0    0    0    0    0    0     0     0     0     0
	d1_3    0    0    0    0    0    0    0    0    0    0     0     0     0     0
	d1_4    0    0    0    0    0    0    0    0    0    0     0     0     0     0
	d1_5    0    0    0    0    0    0    0    0    0    0     0     0     0     0
	     d0_14 d0_15 d0_16 d0_17 d0_18 d0_19 d0_20 d0_21 d0_22 d0_23 d0_24 d0_25
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     1     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     1     0     0     1     0     0     0     0
	d1_5     0     0     0     1     0     0     0     0     0     0     0     0
	     d0_26 d0_27 d0_28 d0_29 d0_30 d0_31 d0_32 d0_33 d0_34 d0_35 d0_36 d0_37
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     0     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     0     0     0     0     0     0     0     0
	d1_5     0     0     0     0     0     0     0     0     0     0     0     0
	     d0_38 d0_39 d0_40 d0_41 d0_42 d0_43 d0_44 d0_45 d0_46 d0_47 d0_48 d0_49
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     0     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     0     0     0     0     0     0     0     0
	d1_5     0     0     0     0     0     0     0     0     0     0     0     0
	     d0_50 d0_51 d0_52 d0_53 d0_54 d0_55 d0_56 d0_57 d0_58 d0_59 d0_60 d0_61
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     0     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     0     0     0     0     0     0     0     0
	d1_5     0     0     0     0     0     0     0     0     0     0     0     0
	     d0_62 d0_63 d0_64 d0_65 d0_66 d0_67 d0_68 d0_69 d0_70 d0_71 d0_72 d0_73
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     0     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     0     0     0     0     0     0     0     0
	d1_5     0     0     0     0     0     0     0     0     0     0     0     0
	     d0_74 d0_75 d0_76 d0_77 d0_78 d0_79 d0_80 d0_81 d0_82 d0_83 d0_84 d0_85
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     0     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     0     0     0     0     0     0     0     0
	d1_5     0     0     0     0     0     0     0     0     0     0     0     0
	     d0_86 d0_87 d0_88 d0_89 d0_90 d0_91 d0_92 d0_93 d0_94 d0_95 d0_96 d0_97
	d1_0     0     0     0     0     0     0     0     0     0     0     0     0
	d1_1     0     0     0     0     0     0     0     0     0     0     0     0
	d1_2     0     0     0     0     0     0     0     0     0     0     0     0
	d1_3     0     0     0     0     0     0     0     0     0     0     0     0
	d1_4     0     0     0     0     0     0     0     0     0     0     0     0
	d1_5     0     0     0     0     0     0     0     0     0     0     0     0
	     d0_98 d0_99 d0_100 d0_101 d0_102 d0_103 d0_104 d0_105 d0_106 d0_107 d0_108
	d1_0     0     0      0      0      0      0      0      0      0      0      0
	d1_1     0     0      0      0      0      0      0      0      0      0      0
	d1_2     0     0      0      0      0      0      0      0      0      0      0
	d1_3     0     0      0      0      0      0      0      0      0      0      0
	d1_4     0     0      0      0      0      0      0      0      0      0      0
	d1_5     0     0      0      0      0      0      0      0      0      0      0
	     d0_109 d0_110 d0_111 d0_112 d0_113 d0_114 d0_115 d0_116 d0_117 d0_118
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_119 d0_120 d0_121 d0_122 d0_123 d0_124 d0_125 d0_126 d0_127 d0_128
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_129 d0_130 d0_131 d0_132 d0_133 d0_134 d0_135 d0_136 d0_137 d0_138
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_139 d0_140 d0_141 d0_142 d0_143 d0_144 d0_145 d0_146 d0_147 d0_148
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_149 d0_150 d0_151 d0_152 d0_153 d0_154 d0_155 d0_156 d0_157 d0_158
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_159 d0_160 d0_161 d0_162 d0_163 d0_164 d0_165 d0_166 d0_167 d0_168
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_169 d0_170 d0_171 d0_172 d0_173 d0_174 d0_175 d0_176 d0_177 d0_178
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_179 d0_180 d0_181 d0_182 d0_183 d0_184 d0_185 d0_186 d0_187 d0_188
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_189 d0_190 d0_191 d0_192 d0_193 d0_194 d0_195 d0_196 d0_197 d0_198
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_199 d0_200 d0_201 d0_202 d0_203 d0_204 d0_205 d0_206 d0_207 d0_208
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_209 d0_210 d0_211 d0_212 d0_213 d0_214 d0_215 d0_216 d0_217 d0_218
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_219 d0_220 d0_221 d0_222 d0_223 d0_224 d0_225 d0_226 d0_227 d0_228
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_229 d0_230 d0_231 d0_232 d0_233 d0_234 d0_235 d0_236 d0_237 d0_238
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_239 d0_240 d0_241 d0_242 d0_243 d0_244 d0_245 d0_246 d0_247 d0_248
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_249 d0_250 d0_251 d0_252 d0_253 d0_254 d0_255 d0_256 d0_257 d0_258
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_259 d0_260 d0_261 d0_262 d0_263 d0_264 d0_265 d0_266 d0_267 d0_268
	d1_0      0      0      0      0      0      0      0      0      0      0
	d1_1      0      0      0      0      0      0      0      0      0      0
	d1_2      0      0      0      0      0      0      0      0      0      0
	d1_3      0      0      0      0      0      0      0      0      0      0
	d1_4      0      0      0      0      0      0      0      0      0      0
	d1_5      0      0      0      0      0      0      0      0      0      0
	     d0_269 d0_270
	d1_0      0      0
	d1_1      0      0
	d1_2      0      0
	d1_3      0      0
	d1_4      0      0
	d1_5      0      0


If you have too many loci, you may need to downsample to the desired number. Here is some code that will downsample the observed SFS to 600 loci. Otherwise, proceed to the simulations step below.

	num_loci <- 600 # set number of loci to keep for each simulation
	n_matrices <- 1
	obs.sub <- data.frame()
	
	index.one <- which(sfs1 == 1) # indices of elements exactly equal to 1
	index.greaterthanone <- which(sfs1 > 1) # indices of elements greater than 1
	adds <- vector()
	for(j in 1:length(index.greaterthanone)){
	  adds <- append(adds, (rep(index.greaterthanone[j], unlist(sfs1)[index.greaterthanone][j]-1)))
	}
	full.nonzeros <- c(index.one, index.greaterthanone, adds)
	sub.sfs <- data.frame()
	sub.sfs <- as.data.frame(table(sample(full.nonzeros,num_loci)))
	
	array.index <- data.frame(Var1 = 1:length(unlist(sfs1))) # Creating a dataframe with the number of indices equal to the number of entries in a 195 x 271 matrix (52845 entries)
	
	array.counts <- merge(array.index,sub.sfs, by = "Var1", all.x = TRUE) # Merge array.index with the randomly sampled index.counts so that I have a dataframe of how many counts at each index
	array.counts[is.na(array.counts)] <- 0 # Replace all the NA's with zeros
	
	sub.dat <- matrix(array.counts$Freq, nrow = 1, ncol = 52845) # Format the list of counts into a matrix (nrow = 195, ncol = 271) or a single row (nrow = 1, ncol = 52845); matrices are filled column-wise
	
	obs.sub <- rbind(obs.sub, sub.dat)
	
	# Regardless of whether you downsampled your .obs file or not, you will need to 'flatten' your .obs file into a single row to match the simulations.
	obs.sumstats <- as.vector(as.matrix(obs)) # 'Flattens' the downsampled joint SFS and will be used later for ABC


## Simulating with fastsimcoal2:

Before beginning the simulations, I highly recommend reading through the fastsimcoal2 manual (<http://cmpg.unibe.ch/software/fastsimcoal2511/man/fastsimcoal25.pdf>) to familiarize yourself with how to structure input files and run fastsimcoal2 on the command line. There is also a Google group where you can seek advice from fastsimcoal2 users (<https://groups.google.com/forum/#!forum/fastsimcoal>). 

Fastsimcoal2 a continuous-time coalescent simulator of genomic diversity under arbitrarily complex evolutionary scenarios. The flexibility of fastsimcoal2 allows you to create simulations based on the complexity of your system and question of interest. Sampling parameter values from prior distributions requires two input files: a template file and an estimation file. The template file describes the demographic model being simulated. The estimation file describes the distribution and prior bounds for the parameters that are to be sampled. Detailed instructions and options for the template and estimation files are described in the fastsimcoal2 manual. Here, I am simulating SNP data (but see Note below) to estimate dispersal (DISP) between two populations of constant size (POPONE & POPTWO).

### **An example template file (migrationABC_test.tpl)**:

	//Anything preceded by // is a comment. You can remind yourself of what is being simulated up here.
	//Number of population samples
	2
	//Population effective sizes (=2N, number of alleles).
	POPONE
	POPTWO
	//Sample sizes: # samples (=2N, number of alleles). These numbers should reflect your observed data.
	270
	194
	//Growth rates. Both populations are not growing in this case.
	0
	0
	//Number of migration matrices : If 0 : No migration between demes
	1
	//migration matrix: sources in rows, sinks in columns (backwards in time). In this example, dispersal from POPONE to POPTWO and vice versa are the same, DISP.
	0 DISP
	DISP 0
	//Historical event format: time, src, sink, % mig, new Ne scaling factor for sink, new r, new mig matrix. No historical events in this case.
	0
	//Number of chromosomes
	10 0
	//Number of linkage blocks on Chromosome 1 (per chromosome)
	1
	//Per Block: Data type, No. of loci, Recombination rate to the right-side locus, plus optional parameters
	DNA 100 0 1E-8 0.33

**A note on simulating SNP data**:

Simulation of SNP data is not as easy as indicating the SNP data type in the template file. There is a section in the fastsimcoal2 manual about the simulation of SNP data; be sure to read it. With the SNP data type, you'll have one mutation irrespective of the length of the genealogy, and mutation rate is irrelevant, so you’ll end up with a biased SFS. Instead, SNP data should be simulated as a DNA fragment. Thus, simulating realistic SNPs using the DNA data type requires some careful thought about the ‘Number of chromosomes’, the DNA sequence length and the mutation rate. Use your observed data to inform how many SNPs should be simulated, and be mindful of how SNPs are being simulated within the context of the computational power available to you. You will likely need to test multiple template files to optimize the number of simulated SNPs. For example, the above template file simulates DNA of sequence length 100 with a mutation rate of 1E-8, which is typical of SNPs. The template file indicates that this should be done 10 times. These settings will get you a handful of SNPs, but if you need more simulated SNPs in order to match your observed data, you will need to increase the ‘Number of chromosomes’. For example, to make sure that I got at least 663 SNPs in each simulation, I set 'Number of Chromosomes' to 1000000 (This is computationally intensive!). Alternatively, you could increase the mutation rate or the DNA sequence length to simulate more SNPs, but then you will have more linked SNPs (I did not do this because I was working with ddRAD data). I also tried simulating DNA of sequence length 1 with a very high value for ‘Number of chromosomes’ but the computation time with these settings was unreasonable.

### **An example template file (migrationABC_test.est)**:
	// Priors and rules file 
	// *********************

	[PARAMETERS]
	//#isInt?	#name	#dist.	#min	#max
	//all N are in number of haploid individuals
	1 POPONE logunif 100 100000 output
	1 POPTWO logunif 100 100000 output
	0 DISP unif 0 0.5 output
	[RULES]

	[COMPLEX PARAMETERS]
	

To start the fastsimcoal2 simulations type:

	./fsc25221 -t migrationABC_test.tpl -e migrationABC_test.est -n 1 -E 500 -g -q -s 0 -m -c 6 -B 12

This command will draw 500 sets of parameters (-E) and perform a single simulation per set (-n). Arlequin project outputs (*.arp ) will be generated in genotypic (-g; diploid) format and the minor allele site frequency spectrum will be computed and output (-m). DNA data is output as SNP data and all SNPs in the DNA sequence are output (-s 0). More options can be found in the fastsimcoal2 manual.

## Manipulating simulations to match the observed data: Removing rare SNPs and downsampling loci

Depending on how you ran your simulations, you may need to modify your simulations to account for any bioinformatic filters you applied to your observed data (i.e. minor allele frequency), and to make sure the number of SNPs in each simulation matches that of your observed data. Below is some example code to remove rare SNPs and downsample each simulation to 600 loci.
	
	## Removing rare SNPs with MAF < 0.05
	# First create a complete theoretical SFS with the MAF counts across populations. This identifies allele combinations having a MAF < 0.05, and therefore need to be removed.
	x <- 0:270
	y <- 0:194

	count.matrix <- matrix(nrow = 195, ncol = 271)
	colnames(count.matrix) <- 0:270
	rownames(count.matrix) <- 0:194
	for (i in 1:ncol(count.matrix)){
  	count.matrix[,i] <- x[i]+y
	}
	
	# Duplicate the count matirx into an array matching the dimensions of the simulations
	count.array <- array(rep(count.matrix, 500), c(195,271,500))
	
	# At this point you should have a data array containing your simulated SFS (data_array in the example below) and a data array of the theoretical SNP counts (count.array). They should have the same dimensions.
	n_matrices <- 500 # number of SFS simulations
	# Replace theoretical SNP counts with zero based on where there are zeros in the simulated SFS matrix
	count.array[which(data_array == 0)] <- 0

	# Divide the array by the number of alleles sampled to get frequency
	freq.array <- count.array/464

	# Then replace any values less than 0.05 with zero
	freq.array[freq.array < .05] <- 0

	# Need to convert the frequncies back to numbers
	count.array2 <- freq.array * 464

	# And now I use this filtered theoretical SNP count array as a template, only keeping combinations of minor alleles in each simulation that have a MAF > 0.05.
	data_array[which(count.array2 == 0)] <- 0
	
	## You might have too many SNPs in your simulations, or not all simulations have the same number of SNPs, so you might need to randomly sample to make sure that the number of loci in each simulation matches your observed data.
	# Downsampling the simulations with MAF > 0.05.
	num_loci <- 600 # set number of loci to keep for each simulation
	n_matrices <- 500 # number of SFS simulations
	sub.sfs.all <- data.frame()

	# This basically creates a distribution of places in each simulated SFS that we can sample from. The number of times a place in the SFS occurs in the distribution depends on how often that combination of minor alleles occurs in the simulation.
	for(i in 1:n_matrices){
  		index.one <- which(data_array[,,i] == 1) # indices of elements exactly equal to 1
  		index.greaterthanone <- which(data_array[,,i] > 1) # indices of elements greater than 1
  		adds <- vector()
  		for(j in 1:length(index.greaterthanone)){
    	adds <- append(adds, (rep(index.greaterthanone[j], (data_array[,,i][index.greaterthanone][j])-1)))
  		}
  	full.nonzeros <- c(index.one, index.greaterthanone, adds) # the indices from the SFS we can sample from
  	sub.sfs <- data.frame()
  	sub.sfs <- as.data.frame(table(sample(full.nonzeros,num_loci))) # this is the where the downsampling actually occurs
  
  	array.index <- data.frame(Var1 = 1:length(as.list(data_array[,,i]))) # Creating a dataframe with the number of indices equal to the number of entries in a 195 x 271 matrix (52845 entries)
  
  	array.counts <- merge(array.index,sub.sfs, by = "Var1", all.x = TRUE) # Merge array.index with the randomly sampled index.counts so that I have a dataframe of how many counts at each index, including indices that weren't sampled. This is important to retain the dimensionality of each downsampled simulated SFS.
  	array.counts[is.na(array.counts)] <- 0 # Replace all the NA's with zeros
  
  	sub.dat <- matrix(array.counts$Freq, nrow = 1, ncol = 52845) # Format the list of counts into a matrix (nrow = 195, ncol = 271) or a single row (nrow = 1, ncol = 52845); matrices are filled column-wise. Each simulated SFS has been 'flattened' into a single row.
  
  	sub.sfs.all <- rbind(sub.sfs.all, sub.dat)
	}
	
You should now have data where each row is a 'flattened' SFS. The sum of each row should be equal to the number of loci in your observed data and the MAF of your observed data should be accounted for. You are now read to do ABC.

## Performing ABC:

There are many ways to actually perform ABC, but I used the abc package (https://cran.r-project.org/web/packages/abc/index.html) in R. To perform ABC, you need to read three things into R: a file with the sampled parameters, a file with the summary statistics of the simulated data and a file with the summary statistics of the observed data. Each line in the parameters and simulated summary statistic files should correspond to the same simulation. At this point, you should have already manipulated the simulated summary statistics to account for any bioinformatics filters that were used on the observed data (i.e. minor allele frequency) and/or down sampled your simulations so that all simulations have the same number of SNPs as your observed data (assuming you use the fastsimcoal2 -s 0 option). The abc ‘tol’ option describes the proportion of accepted simulations closest to the target and the ‘method’ option describes the ABC algorithm to be applied.

To perform ABC using the abc package after you have read in the necessary files:

	calcs <- abc(target = obs.sumstats, param = full_params, sumstat = sub.sfs.all, tol = 0.01, method = 'rejection’)

You can plot your ABC results using the plot.abc fuction in the abc R package if you use the ‘loclinear’ or ‘neuralnet’ method. If you use the ‘rejection’ method, you can plot the ABC results on your own:

	pdf(file = 'abc_filename.pdf')                          # saves plots as a pdf
	par(mfrow = c(2,2))
	popone <- rlunif(1000, 100, 100000)                     # the prior distribution I used for POPONE
	plot(density(popone, bw = 2000, adjust = 1, cut = 3))   # plots POPONE prior distribution
	lines(density(calcs$unadj.values[,1], bw = 2000, adjust = 1, cut = 3), col='blue') # draws density plot of POPONE values from simulations kept from abc 
	poptwo <- rlunif(10000, 100, 100000)                    # the prior distribution I used for POPTWO
	plot(density(poptwo, bw = 2000, adjust = 1, cut = 3))
	lines(density(calcs$unadj.values[,2], bw = 2000, adjust = 1, cut = 3), col='blue')
	disp <- runif(10000, 0, 0.5)                            # the prior distribution I used for DISP
	plot(density(disp, bw = 0.02, adjust = 1, cut =3), ylim = c(0, 3))
	lines(density(calcs$unadj.values[,3], bw = 0.02, adjust = 1, cut = 3), col='blue') 
	dev.off()                                               
	
## ABC Resources:
Bertorelle, G., Benazzo, A.& Mona, S. (2010) ABC as a flexible framework to estimate demography over space and time: some cons, many pros. Molecular Ecology, 19, 2609–2625.

Csilléry, K., François,  O., Blum,  M.G.B. (2012) ABC: An R package for approximate Bayesian computation (ABC). Methods Ecol Evol 3(3):475–479.

Csilléry, K., Blum, M.G.B., Gaggiotti, O.E. & François, O. (2010) Approximate Bayesian computation in practice. Trends in Ecology & Evolution, 25, 410–418.

Fastsimcoal2 Manual <http://cmpg.unibe.ch/software/fastsimcoal2511/man/fastsimcoal25.pdf>
