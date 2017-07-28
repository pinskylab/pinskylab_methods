#**Guide to using the Amarel cluster**

Amarel is a high-performance computer cluster managed by the Rutgers
Office of Advanced Research Computing (OARC; <https://oarc.rutgers.edu/>).
Amarel resources are available to the Rutgers community and are useful
for when you need to perform research computation that exceeds the
resources of your personal computer or the Pinsky Lab cluster,
Amphiprion. This guide describes the steps necessary to get an account
and how to submit and run jobs on Amarel.

##**Getting started**:

To get an account on Amarel, you will need to complete the official
access request form (<https://oarc.rutgers.edu/access/>) and might
consider going to an OARC training session
(<https://oarc.rutgers.edu/events/>) to familiarize yourself with the
Amarel system and how to plan for and submit jobs. Also a basic
familiarity with the command line and bash scripting are very helpful.
If you need to first brush up on the command line, there are many good
tutorials online, including Codecademy.

##**Overview of Amarel & slurm**:

Like many other clusters, Amarel uses an open-source job scheduler
called slurm to manage and schedule jobs. To submit jobs to the slurm
scheduler, you’ll use the sbatch and srun commands depending on the
specifications of your job. It is a good idea to skim through the slurm,
sbatch and srun man pages. The Amarel User Guide
(<http://rci.rutgers.edu/~gc563/amarel/>) also has very useful
information on how to connect to Amarel, install software and run jobs.
Finally, the OARC staff are very helpful and can assist with any issues
(<help@oarc.rutgers.edu>). I highly recommend testing small versions of
your job on Amphiprion and then Amarel before scaling up to full-scale
production on Amarel.

##**Submitting a job**:

Once you have logged into Amarel and installed any necessary software,
you are ready to write a script to submit your jobs to slurm. The
following example describes how to submit a fastsimcoal2 job to Amarel
assuming the fsc25 executable and any fsc25 input files are in
/home/\$USER. If you need to, it is easy to submit this job to Amarel
many times using a simple bash for loop.

	[jah414@fen1 ~]$ less run_fsc.sh

############################

	#!/bin/bash 						  ## Allows script to be run as a bash script	#SBATCH --job-name=fastsimcoal2	 	## All lines starting with #SBATCH set the parameters for the slurm scheduler	#SBATCH --partition=main	#SBATCH -N1						 	## -N is the number of nodes requested for the job 	#SBATCH -n1                        ## -n is the number of tasks for an mpi process -- 28 cores per node on amarel                                       fastsimcoal will use one task, -n1, but can use multiple cores -->   --cpus-per-task=28	#SBATCH --cpus-per-task=28         ## --cpus-per-task is the number of "threads" available per task -- max of 28 cores per node on amarel                                        fastsimcoal will use one task, -n1, but can use multiple cores -->   --cpus-per-task=28                                         --core 1 ,  --core 28 or 14 or a number that performs well. Threads can be any type of thread mechanism like OpenMP, pthreads or similar.                                       For OpenMP,  OMP_NUM_THREADS will need to be set equal or less than cpus-per-task 	#SBATCH --exclusive				 	## indicates I want to use all 28 cores/node
	#SBATCH --nodelist = hal0001		## enter the node where your data on node scratch is located	############################	#SBATCH --mem=120000               ## 128GB /node of amarel. Be sure to request an amount needed for the job.  The ratio of memory to core is 4.2 GB / core.        									(part of the mem. is reserved for the OS and not available to the users job.)	#SBATCH --time=24:00:00            ## max time is 3 days:  3-00:00:00  or  72:00:00. Once you have an accurate time estimate for your jobs try to only request an extra hour or so depending on         								the potential difference in run times.  If you are not sure give the jobs extra time.	#SBATCH --export=ALL	#SBATCH --no-requeue       			## optional: this prevents the job from restarting if the node fails or the job is preempted.	#SBATCH -o slurm-%j.out   			## the default file name is "slurm-%j.out" where %j refers to the JOBID	#SBATCH -e slurm-%j.err	#SBATCH --mail-type=END                # Type of email notification- BEGIN,END,FAIL,ALL	#SBATCH --mail-user=first.last@rutgers.edu # Email to which notifications will be sent
		#############################################################	# standard output is saved in a file:  slurm-$SLURM_JOBID.out 	############################################################# 	# This is where your commands actually start	# Creates a directory named after the JOBID and moves into the created directory. This is where fsc25 output gets written to.	mkdir -p /home/$USER/slurm-out/$SLURM_JOBID	cd       /home/$USER/slurm-out/$SLURM_JOBID	#Create a personal directory on the node scratch disk if needed.	mkdir -p /mint/scratch/$USER/$SLURM_JOBID	# this will tell you when the job started and the host. 	date=`date "+%Y.%m.%d-%H.%M.%S"`	hostname=`hostname`	# to print the variable -- echo	echo $date	echo $hostname	# obtain the environment variables 	# this is useful for reference and troubleshooting issues.	env >               /home/$USER/slurm-out/$SLURM_JOBID/slurm-$SLURM_JOBID-env-all.out	env | grep SLURM >  /home/$USER/slurm-out/$SLURM_JOBID/slurm-$SLURM_JOBID-env-SLURM.out	# start time	date	# start the simulation. This will use all 28 cores on a single node and perform 500 simulations using the specified .tpl and .est input files. Additional program options are specified after fsc25 is called. Information about how the fsc25 run is going is directed into an output file with a .txt extension.	srun -N1 -n1 --cpus-per-task=28 --exclusive --mem=120000 /home/$USER/fsc25221 -t /home/$USER/migrationABC_DNA1millionby100.tpl -e /home/$USER/migrationABC_5729_2_0.5dispersal.est -n 1 -E 500 -g -q -s 0 -m -x --cores 28 --numBatches 28  > /home/$USER/slurm-out/$SLURM_JOBID/$SLURM_JOBID-fastsimcoal2.$SLURM_NNODES.$SLURM_NODELIST.$date.a.txt	# Access to /mnt/scratch is restricted to users with active jobs. If you write to this directory you need to include code within the script to retrieve your data. I did not need to do this because all output files were being written to my home directory, so that is why this part of code is commented out.	# start the data transfer  	# copy data from a node's local disk scratch to the gpfs network scratch or home. 	#    cp -R /mnt/scratch/$USER/$SLURM_JOBID/* /home/$USER/slurm-out/$SLURM_JOBID/ 	# remote copy of node's local disk scratch to remote storage location 	#     scp -rpv /mnt/scratch/$USER/$SLURM_JOBID netid@your.ip.address:~/ 	# alternatively, if you need to review the data manually to select which is needed	# you can have the slurm job just hold a cpu for a few minutes.	# The sbatch time should in theory match the sleep time.	# Be sure to exit so other jobs can run.  Once the job starts you	# will then be able to ssh to the node from the login node.	# #SBATCH --time=01:00:00           ==   sleep 60m	# sleep 60m 	# remove all data created from the job on the local node's disk. 	rm -fr /mnt/scratch/$USER/$SLURM_JOBID 	#end time	date
	
	wait
	
Once everything is working, submit your job to the slurm scheduler using sbatch. Your job will sit in the queue until slurm assigns resources to your job. In the settings of run_fsc.sh I told Amarel to email me when the job ended.
	[jah414@fen1 ~]$ sbatch ./run_fsc.shWhen your job finishes, you can move/manipulate/analyze the output according to your workflow. Below you will find other helpful information about slurm and the Amarel cluster. Happy computing!

##**Helpful slurm commands**:	sbatch run_fsc.sh            # submit a new job, with job settings and specifications in run_fsc.sh	sprio -l | grep netid        # list the priority of the jobs | filter for your jobs	squeue -u netid              # list the queue of jobs | filter for your jobs , check status, get JOBID	scancel JOBID                # cancel a job	scontrol show job JOBID      # show the detail for a job	sinfo                        # show the partitions and current usage	du -hs /home/$USER			 # check your usage in your home directory##**Other useful information**:###**Preemption**:Rutgers PI’s own some of the Amarel HPC resources. Owners have the highest priority to their resources, so some of your jobs may be preempted if an owner needs to run a job. If this happens you will have a message in the slurm-JOBID.out/err files similar to this near the end of the file:	err.37661:slurmstepd: error: *** JOB 37661 ON hal0051 CANCELLED AT 2017-07-10T15:46:02 DUE TO PREEMPTION *** If you request email notification in your sbatch script then you'll also get an email message indicating preemption occurred:
	#SBATCH --mail-type=KILL 	or 	#SBATCH --mail-type=ALL You can control how preempted jobs are dealt with when you set the parameters for the slurm scheduler. My example run_fsc.sh script told slurm to not requeue preempted jobs, so any jobs that do get preempted are canceled.###**Setting up a keyless ssh connection**:This would allow you to connect to Amarel without having to type in your password every time you want to log into Amarel. Note: In the below example, the permissions are being set on specific files and directories with the keys.  These must not change and never be shared as they permit access to your accounts without a password.	# enable ssh to and from the cluster.	# login to amarel:	ssh netid@amarel.hpc.rutgers.edu	/opt/sw/scripts/cluster-env	logout#######################################
	# on your linux client, desktop or storage server	install -d -m 700 $HOME/.ssh	cd ~/.ssh	ssh-keygen -t rsa -b 2048	cat id_rsa.pub >> authorized_keys	chmod 600 id_rsa.pub authorized_keys	scp id_rsa.pub netid@amarel.hpc.rutgers.edu:~/.ssh/id_rsa.pub_myhost#######################################	# on remote server:	# enable key access:	ssh netid@amarel.hpc.rutgers.edu	cat ~/.ssh/id_rsa.pub_myhost >> authorized_keys	logout#######################################	# test key access	ssh netid@amarel.hpc.rutgers.edu	logout#######################################	# on your linux client, desktop or storage server	# obtain cluster key and enable key access to your system.	scp netid@amarel.hpc.rutgers.edu:~/.ssh/cluster.pub $HOME/.ssh/cluster.pub	cat $HOME/.ssh/cluster.pub >> $HOME/.ssh/authorized_keys	chmod 0600 $HOME/.ssh/authorized_keys	echo "   PubkeyAcceptedKeyTypes=+ssh-dss" >> $HOME/.ssh/config	chmod 0600 $HOME/.ssh/config#######################################	# test key access	# get your ipaddress.	hostname	ifconfig	ssh netid@amarel.hpc.rutgers.edu	ssh userid@your.server.ip	logout	logout