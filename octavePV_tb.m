%Script to check that the functions work correctly
close all
clear all
clc

% based on:
% https://github.com/zygurt/TSM/tree/master/Frequency_Domain





%% ------------ Testing Stereo Phase Vocoder functions --------------

pathInput = 'C:/odmkDev/odmkCode/odmkPython/audio/wavsrc/';
filename = 'The_Amen_Break_48K_fakeIntro.wav';

[x, fs] = audioread([pathInput filename]);

%Simple Mono testing
%fs = 48000;
%x = sin(2*pi*777*(linspace(0,3,3*fs))');
%x = [x,x,x,x,x,x];

TSM = 0.8;
N = 2048;


x_plot_limit=960000;
if (length(x) < x_plot_limit)
  figure; plot(x)
else
  figure; plot(x(1:x_plot_limit))
endif;


%Plot the stereo signal
x2 = x./max(max(abs(x)));
x2_plot = [x2(:,1)+1, x2(:,2)-1];
t = (1:length(x2_plot))/fs;
figure
plot([t',t'],x2_plot);
axis([0 max(t) min(min(x2_plot))*1.1 max(max(x2_plot))*1.1])
plot_title = sprintf("%s",strrep(filename(1:end-4),'_',' '));
title(plot_title);

set(gca, 'YLim', [min(min(x2_plot))*1.1 max(max(x2_plot))*1.1],...
    'YTick', -2:1:2,...
    'YTickLabel', {'-1     ', 'Right Amplitude','1, -1', 'Left Amplitude', '1'})



%keyboard

%Stereo Phase Vocoders
y_n = PV(x, N, TSM);
% y_A = PV_Altoe(x, N, TSM);
% y_B = PV_Bonada(x, N, TSM);
% y_MS_Fi = PV_MS_File(x, N, TSM);
% y_MS_Fr = PV_MS_Frame(x, N, TSM);

figure
subplot(6,1,1)
if TSM < 1
  plot((1:length(y_n))/fs,[x ; zeros(length(y_n)-length(x),size(x,2))])
  title('Original (Zero padded to same length as scaled signals)')
else
  plot((1:length(x))/fs,x)
  title('Original')
end
axis tight
xlabel('Time (s)')

subplot(6,1,2)
plot((1:length(y_n))/fs,y_n)
axis tight
title('PV\_naive')
xlabel('Time (s)')
%
% subplot(6,1,3)
% plot((1:length(y_A))/fs,y_A)
% axis tight
% title('PV\_Altoe')
% xlabel('Time (s)')
%
% subplot(6,1,4)
% plot((1:length(y_B))/fs,y_B)
% axis tight
% title('PV\_Bonada')
% xlabel('Time (s)')
%
% subplot(6,1,5)
% plot((1:length(y_MS_Fi))/fs,y_MS_Fi)
% axis tight
% title('PV\_MS\_File')
% xlabel('Time (s)')
%
% subplot(6,1,6)
% plot((1:length(y_MS_Fr))/fs,y_MS_Fr)
% axis tight
% title('PV\_MS\_Frame')
% xlabel('Time (s)')


%Stereo Phase Locking Phase Vocoders
% y_NPL_PV = PL_PV( x, N, TSM, 0 ); %No Phase Locking
% y_IPL_PV = PL_PV( x, N, TSM, 1 ); %Identity
% y_SPL_PV = PL_PV( x, N, TSM, 2 ); %Scaled
%
% figure
%
% subplot(3,1,1)
% plot((1:length(y_NPL_PV))/fs,y_NPL_PV)
% axis tight
% title('NoPL\_PV')
% xlabel('Time (s)')
%
% subplot(3,1,2)
% plot((1:length(y_IPL_PV))/fs,y_IPL_PV)
% axis tight
% title('IPL\_PV')
% xlabel('Time (s)')
%
% subplot(3,1,3)
% plot((1:length(y_SPL_PV))/fs,y_SPL_PV)
% axis tight
% title('SPL\_PV')
% xlabel('Time (s)')



%Phavorit Stereo Phase Locking Phase Vocoders
y_phavorit_IPL_PV = phavorit_PV( x, N, TSM, 0 ); %Identity
y_phavorit_SPL_PV = phavorit_PV( x, N, TSM, 1 ); %Scaled

figure
subplot(2,1,1)
plot((1:length(y_phavorit_IPL_PV))/fs,y_phavorit_IPL_PV)
axis tight
title('y\_Phavorit\_IPL\_PV')
xlabel('Time (s)')

subplot(2,1,2)
plot((1:length(y_phavorit_SPL_PV))/fs,y_phavorit_SPL_PV)
axis tight
title('y\_Phavorit\_SPL\_PV')
xlabel('Time (s)')

##keyboard

%Play original followed by time scaled version
% soundsc(x,fs);
% pause(1.1*length(x)/fs)
% soundsc(y_SPL_PV,fs);
% pause(1.1*length(y_SPL_PV)/fs)
% soundsc(y_Phavorit_SPL_PV,fs);



%% ------------ Checking the find peaks function ------------
%
% channels = 5;
% data_points = 50;
% x = rand(data_points,channels);
% p = find_peaks(x);
% figure
% for c = 1:size(x,2)
%     subplot(size(x,2),1,c)
%     %Plot the original signal
%     stem(x(:,c))
%     hold on
%     %Plot the peak locations
%     for a = 1:length(p(c).pa)
%         subplot(size(x,2),1,c)
%         line([p(c).pa(a),p(c).pa(a)],[0,x(p(c).pa(a),c)],'Color','red');
%     end
%     %Plot the region
%     for a = 1:length(p(c).rl)
%         subplot(size(x,2),1,c)
%         line([p(c).rl(a),p(c).ru(a)],[-0.1,-0.1],'Color','magenta');
%     end
%     title(sprintf('Channel %d',c));
%     hold off
% end

%% ------------ Checking the previous peak function ------------
%
% frames = 3;
% data_points = 50;
% x = rand(data_points,frames);
% p = find_peaks(x);
% figure
% for c = 1:size(x,2)
%     subplot(size(x,2),1,c)
%     %Plot the original signal
%     stem(x(:,c))
%     hold on
%     %Plot the peak locations
%     for a = 1:length(p(c).pa)
%         subplot(size(x,2),1,c)
%         line([p(c).pa(a),p(c).pa(a)],[0,x(p(c).pa(a),c)],'Color','red');
%     end
%         %Plot the region
%     for a = 1:length(p(c).rl)
%         subplot(size(x,2),1,c)
%         line([p(c).rl(a),p(c).ru(a)],[-0.1,-0.1],'Color','magenta');
%     end
%     %Plot the previous peak locations
%     if(c>1)
%         for a = 1:length(p(c).pa)
%             prev_p = previous_peak(p(c).pa(a) , p(c-1).pa , p(c-1).rl , p(c-1).ru);
%             %Plot arrow from current peak to previous peak
%             quiver(p(c).pa(a), ... %x
%                    x(p(c).pa(a),c), ... %y
%                    prev_p-p(c).pa(a), ... %delta x
%                    x(prev_p,c-1)-x(p(c).pa(a),c), ... %delta y
%                    0, 'k'); %Remove scaling
%             %Plot the previous peak
%             %line([prev_p,prev_p],[0,x(p(c-1).pa(a),c-1)],'Color','green','LineStyle','--');
%         end
%     end
%     hold off
%     axis([1 data_points -0.2 1.1])
%     title(sprintf('Frame %d',c));
%
% end

% ------------ Checking the find peaks log function ------------

 channels = 4;
 data_points = 128;
 x = rand(data_points,channels);
 p = find_peaks_log(x);
 figure
 for c = 1:size(x,2)
     subplot(size(x,2),1,c)
     %Plot the original signal
     stem(x(:,c))
     hold on
     %Plot the peak locations
     for a = 1:length(p(c).pa)
         subplot(size(x,2),1,c)
         line([p(c).pa(a),p(c).pa(a)],[0,x(p(c).pa(a),c)],'Color','red');
     end
     %Plot the region
     for a = 1:length(p(c).rl)
         subplot(size(x,2),1,c)
         line([p(c).rl(a),p(c).ru(a)],[-0.1,-0.1],'Color','magenta');%,'Marker','.');
     end
     title(sprintf('Channel %d',c));
     hold off
 end

% ------------ Checking the previous peak function ------------

 frames = 3;
 data_points = 256;
 x = rand(data_points,frames);
 p = find_peaks_log(x);
 figure
 for c = 1:size(x,2)
     subplot(size(x,2),1,c)
     %Plot the original signal
     stem(x(:,c))
     hold on
     %Plot the peak locations
     for a = 1:length(p(c).pa)
         subplot(size(x,2),1,c)
         line([p(c).pa(a),p(c).pa(a)],[0,x(p(c).pa(a),c)],'Color','red');
     end
     %Plot the region
     for a = 1:length(p(c).rl)
         subplot(size(x,2),1,c)
         line([p(c).rl(a),p(c).ru(a)],[-0.1,-0.1],'Color','magenta');
     end
     %Plot the previous peak locations
     if(c>1)
         for a = 1:length(p(c).pa)
             prev_p = previous_peak_heuristic(p(c).pa(a) , p(c-1).pa , p(c-1).rl , p(c-1).ru);
             %Plot arrow from current peak to previous peak
             if prev_p >0
                 quiver(p(c).pa(a), ... %x
                     x(p(c).pa(a),c), ... %y
                     prev_p-p(c).pa(a), ... %delta x
                     x(prev_p,c-1)-x(p(c).pa(a),c), ... %delta y
                     0, 'k'); %Remove scaling
             else
                 quiver(p(c).pa(a), ... %x
                     x(p(c).pa(a),c), ... %y
                     0, ... %delta x
                     0.1, ... %delta y
                     0); %Remove scaling
             end
             %Plot the previous peak
             %line([prev_p,prev_p],[0,x(p(c-1).pa(a),c-1)],'Color','green','LineStyle','--');
         end
     end
     hold off
     axis([1 data_points -0.2 1.1])
     title(sprintf('Frame %d',c));

 end