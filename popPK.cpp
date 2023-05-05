$PARAM @annotated
TVKA : 1 : Absorption rate constant
TVCL : 1 : Clearance
TVVC : 1 : Central volume
TVF : 1 : Gut Bioavailability

$CMT GUT CENT

$MAIN
// Define parameters
double KA = TVKA*exp(ETA(1));
double CL = TVCL*exp(ETA(2));
double VC = TVVC*exp(ETA(3));
double FGUT = TVF*exp(ETA(4));

F_GUT = FGUT;

// Define rate constants
double k10 = CL/VC;


// Define omega and sigma
$OMEGA 0 0 0 0 
$SIGMA @labels PROP ADD
0 0

$ODE
// Define ODEs for a 3-cmt model with depot compartment
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT - k10*CENT;


$TABLE
double IPRED = CENT/VC;
double DV = IPRED*(1+PROP)+ADD;


$CAPTURE IPRED DV CL