
################################################################################
# START ANALYSIS
################################################################################

puts "ooo Analysis: Pushover ooo" 

################################################################################
# SET RECORDERS
################################################################################

# Global behaviour
recorder  Node  -file Pushover_Horizontal_ReactionsX.out  -time  -node $N_A0 $N_B0 $N_C0 $N_D0 -dof 1  reaction
recorder  Node  -file Pushover_Storey_DisplacementX.out  -time  -node $N_A1 $N_B1 $N_C1 $N_D1 -dof 1 disp    

################################################################################
# ANALYSIS
################################################################################ 

set tStart [clock clicks -milliseconds] 

# Apply lateral load based on first mode shape in x direction (EC8-1)
set phi1 1;
  # pattern PatternType $PatternID TimeSeriesType
    pattern    Plain        2             1      {
    # load $nodeTag (ndf $LoadValues)
      load    $N_A1     [expr $mass1*$phi1] 0.0 0.0 0.0 0.0 0.0 
      load    $N_B1     [expr $mass1*$phi1] 0.0 0.0 0.0 0.0 0.0 
      load    $N_C1     [expr $mass1*$phi1] 0.0 0.0 0.0 0.0 0.0 
      load    $N_D1     [expr $mass1*$phi1] 0.0 0.0 0.0 0.0 0.0
    };

# Define step parameters
 set step +1.000000E-05; 
 set numbersteps  10000;

# Constraint Handler 
constraints  Transformation 
# DOF Numberer 
numberer  RCM 
# System of Equations 
system  BandGeneral 
# Convergence Test           
test  NormDispIncr  0.00001   100   
#algorithm NewtonLineSearch <-type $typeSearch> <-tol $tol> <-maxIter $maxIter> <-minEta $minEta> <-maxEta $maxEta> 
algorithm  NewtonLineSearch -type Bisection -tol +8E-1 -maxIter 1000 -minEta 1E-1 -maxEta 1E1 pFlag 1 
#integrator DisplacementControl $node $dof $incr <$numIter $?Umin $?Umax>            100 +5.000000E-08 +5.000000E-06   
integrator  DisplacementControl $N_A1 1    $step 
# Analysis Type 
analysis  Static 

# Record initial state of model  
record

# Analyze model 
analyze  $numbersteps 

# Stop timing of this analysis sequence 
set tStop [clock clicks -milliseconds] 
puts "o Time taken: [expr ($tStop-$tStart)/1000.0] sec" 

# Reset for next analysis sequence 
wipe 
