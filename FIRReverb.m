% (c) daniel ford, daniel.jb.ford@gmail.com

clear all; clc;
display('**** FIR reverberator ****');
display('**** daniel ford, spring 2014 ****');

% read in file and tap selections
filename = input('Filename: ','s'); 
[x,fs] = audioread(filename);
taps =  [0.03 0.05 0.15 0.1 0.25];   % values in seconds
b_t =   [0.8 0.5 0.8 0.7 0.55];
taps = int32(taps*fs);          % converted to samples  
decay = 1.1;
repeats = 6;  
  
% set constants
N1 = 1;
N2 = length(x);
x1 = x(N1:N2);
x1 = [x1; zeros(1e5, 1)]; % extend sample to allow reverb to decay

% set up echoes and coefficient array
b = zeros(1,max(taps)*repeats);
for i=1:repeats
  for j=1:length(taps)
    b(i*taps(j)) = b_t(j)/i^decay;
  end
end
b(1) = 1;
  
% filter the sound (create delay)
y = filter(b,1,x1);
sound(y,fs);   % play back

% graph the results
[H,w] = freqz(b,1); % Compute frequency response of filter.
plot(w/pi,abs(H)) % Plot the gain vs. digital frequency (0 to pi).
xlabel('normalized frequency (rad/rad)');
ylabel('magnitude');
axis([0 1 0 10]);

% allow user to restart program for speed
cmd = input('Press X to exit or R to restart: ','s');
if cmd == 'r' || cmd == 'R'
  run('exp2a.m')
end
if cmd == 'x' || cmd == 'X'
  return
end