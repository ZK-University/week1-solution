pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom"; // hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component mul = matMul(n,n,1);

    for (var i=0; i < n; i++) {
        mul.b[i][0] <== x[i];
        for (var j=0; j < n; j++) {
            mul.a[i][j] <== A[i][j];
        }
    }

    component equal[n+1];
    component sum = matElemSum(n,1);

    for (var i=0; i < n; i++) {
        equal[i] = IsEqual();
        equal[i].in[0] <== mul.out[i][0];
        equal[i].in[1] <== b[i];
        sum.a[i][0] <== equal[i].out;
    }

    equal[n] = IsEqual();
    equal[n].in[0] <== sum.out;
    equal[n].in[1] <== n;

    out <== equal[n].out;
}

component main {public [A, b]} = SystemOfEquations(3);