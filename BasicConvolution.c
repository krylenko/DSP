/* (c) daniel ford, daniel.jb.ford@gmail.com */

/* basic convolution */

#include <stdlib.h>
#include <stdio.h>

/*
This function implements causal convolution according to
y(n) = SUM_{k=0}^{M-1} h(k) x(n-k)
The input signal x(n) is given for 0 <= n < L. The impulse response h(n)
is given for 0 <= n < M, which is *different* from the 0 <= n <= M range
used for b(n) in the filter() function. Assume zero initial conditions.
The main program allocates the three arrays and fills the x and h arrays.
This function then computes y(n) for 0 <= n < L.
Inputs: x[], L, h[], M. Output: y[].
*/

void conv(float x[], int L, float h[], int M, float y[]);

int main(int argc, char **argv){

  /* init variables */
  float * x, * h_FIR, * y;
  int L = 31; int M = 19; int i = 0; int padsize = L+M-1;

  /* allocate memory, zero out arrays */
  x = malloc(padsize * sizeof x); if(x == NULL) return -1;
  for(i=0;i<L;++i) x[i] = 1; /* step response */
  for(i=L;i<padsize;++i) x[i] = 0; /* padded with zeros */
  
  y = malloc(padsize * sizeof y); if(y == NULL) return -1;  
  for(i=0;i<padsize;++i) y[i] = 0;

  h_FIR = malloc(padsize * sizeof h_FIR); if(h_FIR == NULL) return -1;
  for(i=0;i<padsize;++i) h_FIR[i] = 0;
  
  /* load h(n) from previous problem to set up h_FIR */
  FILE *inp;
  inp = fopen("3c_out.txt","r");
  for(i=0;i<M;++i){
    fscanf(inp,"%f",&h_FIR[i]); /* dummy read to get rid of n index */
    fscanf(inp,"%f",&h_FIR[i]);
    fflush(NULL);
  }
  
  /* run convolution */
  printf("\nStarting execution...\n");
  conv(x,L,h_FIR,M,y);
  printf("Finished!\n");
  
  return 0;

}

/* function definition */
void conv(float x[], int L, float h[], int M, float y[]){
  int n = 0; int k = 0; int padsize = L+M-1;

  /* file handle for plotting */
  FILE *outp;
  outp=fopen("3e_out.txt","w");
  
  /* do convolution */
  for(n=0;n<padsize;++n){
    y[n] = 0;
    for(k=0;k<n;++k) y[n] += h[k] * x[n-k];
    fprintf(outp,"%d\t%f\n",n,y[n]);
  }
  
  fclose(outp);
  
}