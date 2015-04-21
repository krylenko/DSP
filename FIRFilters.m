% (c) daniel ford, daniel.jb.ford@gmail.com

% causal FIR BPF w/ Hamming windows

clear all; clc;
w1 = 0.3*pi;
w2 = 0.6*pi;

%*** Type I - symmetric, odd length
L = 7; M = L-1; shift = M/2;

% create ideal impulse response
hd = zeros(L,1);
for n = 0:M
  hd(n+1) = (sin(w2*(n-shift)) - sin(w1*(n-shift)))/(pi*(n-shift));
end
hd(shift+1) = (w2-w1)/(2*pi); 
hsave = hd;
h = hd .* hamming(L);       % mult by window to create filter
[H1 w] = freqz(h,1,128);    % calculate frequency response
H1 = abs(H1)/max(abs(H1));
h'

%*** Type II - symmetric, even length
L = 8; M = L-1; shift = M/2;

% create ideal impulse response
hd = zeros(L,1);
for n = 0:M
  hd(n+1) = (sin(w2*(n-shift)) - sin(w1*(n-shift)))/(pi*(n-shift));
end
h = hd .* hamming(L);       % mult by window to create filter
[H2 w] = freqz(h,1,128);    % calculate frequency response
H2 = abs(H2)/max(abs(H2));
h'

%*** Type III - anti-symmetric, odd length
L = 7; M = L-1; shift = M/2;

% create ideal impulse response
hd = zeros(L,1);
for n = 0:M
  hd(n+1) = (cos(w2*(n-shift)) - cos(w1*(n-shift)))/(pi*(n-shift));
end
hd(shift+1) = 0;            
h = hd .* hamming(L);       % mult by window to create filter
[H3 w] = freqz(h,1,128);    % calculate frequency response
H3 = abs(H3)/max(abs(H3));
h'

%{
% plot the impulse response
%subplot(2,1,1);
stem(h)
title('BPF using Hamming window')
xlabel('n')
ylabel('h(n)')
%}

%*** Type IV - anti-symmetric, even length
L = 8; M = L-1; shift = M/2;

% create ideal impulse response
hd = zeros(L,1);
for n = 0:M
  hd(n+1) = (cos(w2*(n-shift)) - cos(w1*(n-shift)))/(pi*(n-shift));
end            
h = hd .* hamming(L);       % mult by window to create filter
[H4 w] = freqz(h,1,128);    % calculate frequency response
H4 = abs(H4)/max(abs(H4));
h'

% plot the magnitude frequency responses
%subplot(2,1,2);
semilogy(w/pi,[H1 H2 H3 H4])
title('Causal FIR BPF Magnitude Responses')
xlabel('w')
ylabel('H(w) (normalized)')
axis([0 1 1e-2 2])
grid on
legend('Type I','Type II','Type III','Type IV');