clc
clear
vidObj = VideoReader('monke2.mp4'); %image processing
numFrames = 0;
errorframes=0;
celling= round(vidObj.NumFrames-(vidObj.NumFrames/vidObj.FrameRate))-1;
iwant = cell(1,vidObj.NumFrames);
dict = cell(1,celling);
code = cell(1,celling);
E= cell(1,celling);
N= cell(1,celling);
p= cell(1,celling);
final = cell(1,vidObj.NumFrames);
while hasFrame(vidObj)    %dissect the video into frames
    F = readFrame(vidObj);    %read each frame
    numFrames = numFrames + 1;
    iwant{numFrames} = F ;
    I{numFrames} = F;
    for j = 2:30
        if numFrames==vidObj.NumFrames
            break
        end
        temp = readFrame(vidObj);
        numFrames = numFrames + 1;
        iwant{numFrames} = temp ;
        P = iwant{numFrames-1};
        errorframes=errorframes+1;
        E{errorframes} = abs(iwant{numFrames}, P); %kanoniko-provlepsi
        N{errorframes}= imhist(E{1, errorframes});
        p{errorframes}= N{errorframes}/sum(N{errorframes});%gia huffman
        dict{errorframes} = huffmandict(0:255,p{errorframes}); %we needed Communications Toolbox 
        v = vertcat(E{1,errorframes}(:));
        %x = [x ;v];
        code{errorframes} = huffmanenco(v,dict{errorframes});
        %x=[x;code];
    end
    %entropia eikonas sfalmaton
    %N{numFrames}=imhist(iwant{1,numFrames});
    %p{numFrames}=N{numFrames}/sum(N{numFrames});
    %entropy{numFrames}= sum(p{numFrames}.*log2(1./(p{numFrames})));
    
    %imagesc(F)
    %drawnow
    %I1=P1
    %kanoniko1-P1=P2
end
disp('Encoding complete.');
numFrames
%sig = huffmandeco(code,dict);
%resh = reshape(sig, 480, 852, []);
%decoded = uint8(resh);
%test{1}= iwant{1,1}+decoded;

%decoder
Iframeidx=1;
Errorframeidx = 1;
while(Iframeidx<=vidObj.NumFrames)
   final{Iframeidx} = I{Iframeidx};
   Iframeidx = Iframeidx + 1;
   for r = 2:30
      disp(Iframeidx);
      if Iframeidx>vidObj.NumFrames
           break
      end
      sig = uint8(reshape(huffmandeco(code{Errorframeidx}, dict{Errorframeidx}), vidObj.Height, vidObj.Width, []));
      %resh = reshape(sig, vidObj.Height, vidObj.Width, []);
      %decoded = uint8(resh);
      final{Iframeidx} = final{Iframeidx-1} + sig;
      Iframeidx = Iframeidx + 1;
      Errorframeidx = Errorframeidx + 1;
   end
end

video1 = VideoWriter('monke3');
open(video1);
for i= 1:vidObj.NumFrames
    writeVideo(video1,final{i});
end
close(video1);
%visualisation for the error image
video2 = VideoWriter('monke4');
open(video2);
for i= 1:celling
    writeVideo(video2,E{i});
end
close(video2);
%run length encoding
%{
y=[];
c=1;
for i=1:length(x)-1
    if(x(i)==0 || x(i)==1)
        if(x(i)==x(i+1))
            c=c+1;
        else
            y=[y,c,x(i),];
        c=1;
        end
    end
end
y=[y,c,x(length(x))];
%}


%imagesc(iwant{1,145})