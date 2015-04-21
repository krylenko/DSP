% (c) daniel ford, daniel.jb.ford@gmail.com

clear all; clc;
display('**** IIR plain reverberator ****');
display('**** daniel ford, spring 2014 ****');

% read in file and tap selections
filename = input('Filename: ','s'); 
[x,fs] = audioread(filename);
taps =  [0.03 0.05 0.15];   % values in seconds
a1 =   [0.2 0.3 0.4];
taps = int32(taps*fs);          % converted to samples

% set constants
N1 = 1;
N2 = length(x);
x1 = x(N1:N2);
x1 = [x1; zeros(1e5, 1)]; % extend sample to allow reverb to decay

% set up echoes and coefficient array
a = zeros(1,max(taps)+1);
for j=1:length(taps)
  a(taps(j)) = a1(j);
end
a(1) = 1;

% filter the sound (create delay)
y = filter(1,a,x1);
sound(y,fs);   % play back

% graph the results
[H,w] = freqz(1,a); % Compute frequency response of filter.
subplot(2,1,1);
plot(w/pi,abs(H)) % Plot the gain vs. digital frequency (0 to pi).
xlabel('normalized frequency (rad/rad)');
ylabel('magnitude');
axis([0 1 0 10])

% graph impulse response
[h_imp, t] = impz(1,a);
subplot(2,1,2);
plot(t,h_imp);
axis([0 1.6e4 -0.5 0.5])
ylabel('impulse response h(n)');
xlabel('n (F_{s} = 8000 samples/sec)');

% allow user to restart program for speed
cmd = input('Press X to exit or R to restart: ','s');
if cmd == 'r' || cmd == 'R'
  run('exp2b.m')
end
if cmd == 'x' || cmd == 'X'
  return
end