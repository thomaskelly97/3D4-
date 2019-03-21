echo "ANALYSIS STARTS"
rm dphil.pml.trail

echo "SIMULATE 100 STEPS"
run spin -u100 dphil.pml

echo ""

echo "COMPILE VERIFIER"

spin -a dphil.c 
cc -o pan pan.c 
./pan 
echo ""

echo "STANDARD VERIFICATION"

spin -p -t model.pml 
echo ""

echo "PROGRESS VERIFICATION"
spin -a dphil.c 
cc -DNP -o pan pan.c 
./pan -l

echo ""
echo "ANALYSIS COMPLETE"
