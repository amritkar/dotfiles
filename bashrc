# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export PATH=/scratch/amritkar/scripts:$PATH
#export TERM=screen

# Intel fortran compiler enviroment variable setup
#source /opt/intel/bin/ifortvars.sh intel64

# OpenMPI path (intel fortran compatible)
#export PATH=/usr/local/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# TAU path
export TAU_COMM_MATRIX=1

#export TAU_MAKEFILE=/opt/tau-2.20.3/x86_64/lib/Makefile.tau-icpc-papi-mpi-pdt
#export TAU_MAKEFILE=/opt/tau-2.20.3/x86_64/lib/Makefile.tau-icpc-papi-mpi-pdt-openmp-opari
#export TAU_MAKEFILE=/opt/tau-2.20.3/x86_64/lib/Makefile.tau-icpc-pdt-openmp-opari
#export TAU_OPTIONS='-optCompInst -optVerbose'


export OMP_NUM_THREADS=1

#export TOOLROOT=$HOME/toolroot
#export LD_LIBRARY_PATH=$TOOLROOT/usr/lib/gcc-lib/ia64-open64-linux/0.16
#export DRAGON_PATH=$HOME/dragon
#export PATH=$TOOLROOT/usr/bin:$HOME/dragon:$PATH

# PGI paths
#export LM_LICENSE_FILE=/opt/pgi/license.dat
#PATH=/opt/pgi/linux86-64/10.6/bin:$PATH
#PATH=/opt/pgi/linux86-64/2010/mpi/mpich/bin:$PATH
#export PATH
#PGRSH=ssh
#export PGRSH

# man auto command complete
complete -cf man

# git color
export LESS="-F -X -R"

#-------------------------------------------------------------
# Greeting, motd etc...
#-------------------------------------------------------------

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color
# --> Nice. Has the same effect as using "ansi.sys" in DOS.


# Looks best on a terminal with black background.....
# echo -e "${CYAN}This is BASH ${RED}${BASH_VERSION%.*}\
#${CYAN} - DISPLAY on ${RED}$DISPLAY${NC}\n"
#date
#if [ -x /usr/games/fortune ]; then
#	    /usr/games/fortune -s     # Makes our day a bit more fun.... :-)
#fi

#function _exit()        # Function to run upon exit of shell.
#{
#      echo -e "${RED}Hasta la vista${NC}"
#}
#trap _exit EXIT
