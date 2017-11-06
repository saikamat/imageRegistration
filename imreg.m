a = imread('saturn.tif');
b = imread('saturn.tif');
subplot(3,3,1)
imshow(a)
subplot(3,3,2)
 imshow(b)   

% non-interactively
ra = [111 33 65 58];
rb = [111 33 65 58];
sa = imcrop(a,ra);
sb = imcrop(b,rb);

% OR 
   
% interactively
%[sub_onion,rect_onion] = imcrop(onion); % choose the pepper below the onion
%[sub_peppers,rect_peppers] = imcrop(peppers); % choose the whole onion

% display sub images
subplot(3,3,3)
 imshow(uint8(sa))
subplot(3,3,4)
 imshow(uint8(sb))  
 
c = normxcorr2(sb(:,:,1),sa(:,:,1))
subplot(3,3,5)
 surf(c), shading flat
% offset found by correlation
[max_c, imax] = max(abs(c(:)));
[ypeak, xpeak] = ind2sub(size(c),imax(1));
[h,i]=size(c);
corr_offset = [(xpeak-size(sa,2)) 
               (ypeak-size(sa,1))];

% relative offset of position of subimages
rect_offset = [(rb(1)-ra(1)) 
               (rb(2)-ra(2))];

% total offset
offset = corr_offset + rect_offset;
xoffset = offset(1);
yoffset = offset(2);

xbegin = xoffset+1;
xend   = xoffset+ size(a,2);
ybegin = yoffset+1;
yend   = yoffset+size(a,1);

% extract region from peppers and compare to onion
eb = a(ybegin:yend,xbegin:xend,:)
if isequal(b,eb) 
   disp('a was extracted from b')
end
recovered_b = uint8(zeros(size(a)));
recovered_b(ybegin:yend,xbegin:xend,:) = b;
subplot(3,3,6)
 imshow(recovered_b)


[m,n,p] = size(a);
mask = ones(m,n); 
i = find(recovered_b(:,:,1)==0);
mask(i) = .2; % try experimenting with different levels of 
              % transparency

% overlay images with transparency
subplot(3,3,7)
 imshow(a(:,:,1)) % show only red plane of peppers
hold on
subplot(3,3,8)
h = imshow(recovered_b); % overlay recovered_onion
set(h,'AlphaData',mask)



