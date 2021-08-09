%--------------------------------------------------
%Part I
%Manually add noise and do fft and ifft accordingly
%--------------------------------------------------

F=imread('moonlanding.png'); % read the gs image
im_size=size(F);% Obtain the size of the image
P=2*im_size(1);
Q=2*im_size(2); % Obtaining padding parameters as 2*image size
FS=fft2(double(F),P,Q);
%caculate the max value of specturm
                    %--------------
                    %QUESTION1
                    %--------------
FSmax=max(FS(:));
fprintf("FSmax is:%d\n", FSmax);
Fim=fftshift(FS);%move spectrum to center of imag

%caculate the coordinates of noise points
%center point coordinate
x_o=P/2+1; y_o=Q/2+1;
%east noise point
%distance from noise point to center
d=100; offset=100/sqrt(2);
%east point
x_e=x_o; y_e=y_o+d;
%north east point
x_ne=round(x_o-offset); y_ne=round(y_o+offset);
%north point
x_n=x_o-d; y_n=y_o;
%north west point
x_nw=round(x_o-offset); y_nw=round(y_o-offset);
%west point
x_w=x_o; y_w=y_o-d;
%south west point
x_sw=round(x_o+offset); y_sw=round(y_o-offset);
%south point
x_s=x_o+d; y_s=y_o;
%south east point
x_se=round(x_o+offset); y_se=round(y_o+offset);
%south west point
%set neighbourhood of abouve points specified value
Fim_copy=Fim;
[Fim_copy(x_e-1,y_e+1),Fim_copy(x_e,y_e+1),Fim_copy(x_e+1,y_e+1),...
 Fim_copy(x_e-1,y_e),Fim_copy(x_e,y_e),Fim_copy(x_e+1,y_e),...
 Fim_copy(x_e-1,y_e-1),Fim_copy(x_e,y_e-1),Fim_copy(x_e+1,y_e-1)]=deal(FSmax/10);

[Fim_copy(x_se-1,y_se+1),Fim_copy(x_se,y_se+1),Fim_copy(x_se+1,y_se+1),...
 Fim_copy(x_se-1,y_se),Fim_copy(x_se,y_se),Fim_copy(x_se+1,y_se),...
 Fim_copy(x_se-1,y_se-1),Fim_copy(x_se,y_se-1),Fim_copy(x_se+1,y_se-1)]=deal(FSmax/10);

[Fim_copy(x_s-1,y_s+1),Fim_copy(x_s,y_s+1),Fim_copy(x_s+1,y_s+1),...
 Fim_copy(x_s-1,y_s),Fim_copy(x_s,y_s),Fim_copy(x_s+1,y_s),...
 Fim_copy(x_s-1,y_s-1),Fim_copy(x_s,y_s-1),Fim_copy(x_s+1,y_s-1)]=deal(FSmax/10);

[Fim_copy(x_sw-1,y_sw+1),Fim_copy(x_sw,y_sw+1),Fim_copy(x_sw+1,y_sw+1),...
 Fim_copy(x_sw-1,y_sw),Fim_copy(x_sw,y_sw),Fim_copy(x_sw+1,y_sw),...
 Fim_copy(x_sw-1,y_sw-1),Fim_copy(x_sw,y_sw-1),Fim_copy(x_sw+1,y_sw-1)]=deal(FSmax/10);

[Fim_copy(x_w-1,y_w+1),Fim_copy(x_w,y_w+1),Fim_copy(x_w+1,y_w+1),...
 Fim_copy(x_w-1,y_w),Fim_copy(x_w,y_w),Fim_copy(x_w+1,y_w),...
 Fim_copy(x_w-1,y_w-1),Fim_copy(x_w,y_w-1),Fim_copy(x_w+1,y_w-1)]=deal(FSmax/10);

[Fim_copy(x_nw-1,y_nw+1),Fim_copy(x_nw,y_nw+1),Fim_copy(x_nw+1,y_nw+1),...
 Fim_copy(x_nw-1,y_nw),Fim_copy(x_nw,y_nw),Fim_copy(x_nw+1,y_nw),...
 Fim_copy(x_nw-1,y_nw-1),Fim_copy(x_nw,y_nw-1),Fim_copy(x_nw+1,y_nw-1)]=deal(FSmax/10);

[Fim_copy(x_n-1,y_n+1),Fim_copy(x_n,y_n+1),Fim_copy(x_n+1,y_n+1),...
 Fim_copy(x_n-1,y_n),Fim_copy(x_n,y_n),Fim_copy(x_n+1,y_n),...
 Fim_copy(x_n-1,y_n-1),Fim_copy(x_n,y_n-1),Fim_copy(x_n+1,y_n-1)]=deal(FSmax/10);

[Fim_copy(x_ne-1,y_ne+1),Fim_copy(x_ne,y_ne+1),Fim_copy(x_ne+1,y_ne+1),...
 Fim_copy(x_ne-1,y_ne),Fim_copy(x_ne,y_ne),Fim_copy(x_ne+1,y_ne),...
 Fim_copy(x_ne-1,y_ne-1),Fim_copy(x_ne,y_ne-1),Fim_copy(x_ne+1,y_ne-1)]=deal(FSmax/10);
                    
D0 = 100; W=8;
Filter_ideal = band_reject_filters('ideal', P, Q, D0,W); 
Filter_btw = band_reject_filters('btw', P, Q, D0,W); 
Filter_gaussian = band_reject_filters('gaussian', P, Q, D0,W); 
%center the filter
Ff_ideal=fftshift(Filter_ideal);
Ff_btw=fftshift(Filter_btw);
Ff_gaussian=fftshift(Filter_gaussian);

                    %--------------
                    %QUESTION5
                    %--------------
Fim_copy_log=log(1+abs(Fim_copy));
Fim_copy_norm=mat2gray(Fim_copy_log)*255;
ideal_filtered_spec=uint8(Ff_ideal.*Fim_copy_norm);
figure(5)
imshow(ideal_filtered_spec,[]);
imwrite(ideal_filtered_spec,'ideal_filtered_spec_man.png');
title('ideal filtered spec');

btw_filtered_spec=uint8(Ff_btw.*Fim_copy_norm);
figure(6)
imshow(btw_filtered_spec,[]);
imwrite(btw_filtered_spec,'btw_filtered_spec_man.png');
title('btw filtered spec');

gaussian_filtered_spec=uint8(Ff_gaussian.*Fim_copy_norm);
figure(7)
imshow(gaussian_filtered_spec,[]);
imwrite(gaussian_filtered_spec,'gaussian_filtered_spec_man.png');
title('gaussian filtered spec');
                    %--------------
                    %QUESTION8
                    %--------------
ideal_image=uint8(abs(ifft2(Ff_ideal.*Fim_copy))); % multiply the FT of
ideal_image=ideal_image(1:im_size(1), 1:im_size(2));
figure(8)
imshow(ideal_image,[]);
title('ideal image');
imwrite(ideal_image,'ideal_image_man.png');

btw_image=uint8(abs(ifft2(Ff_btw.*Fim_copy))); % multiply the FT of
btw_image=btw_image(1:im_size(1), 1:im_size(2));
figure(9)
imshow(btw_image,[]);
title('btw image');
imwrite(btw_image,'btw_image_man.png');

gaussian_image=uint8(abs(ifft2(Ff_gaussian.*Fim_copy))); % multiply the FT of
gaussian_image=gaussian_image(1:im_size(1), 1:im_size(2));
figure(10)
imshow(gaussian_image,[]);
title('gaussian image');
imwrite(gaussian_image,'gaussian_image_man.png');

function H_out = band_reject_filters(filter_type, P, Q, D0,W)
%  Developing frequency domain coordinates
u = 0:(P-1);
v = 0:(Q-1);

idx = find(u > P/2);
u(idx) = u(idx) - P;
idy = find(v > Q/2);
v(idy) = v(idy) - Q;
% Compute the meshgrid coordinates
[V, U] = meshgrid(v, u);
% Compute the istance matrix
D = sqrt(U.^2 + V.^2);

% Begin fiter computations.
switch filter_type
    case 'ideal'
        H2=double(D<=D0+W/2);
        H1=double(D<=D0-W/2);
        H_out=1-(H2-H1);
    case 'btw'
        H_out = 1./(1 + (D.*W./(D.^2-D0^2)).^(2*4));
    case 'gaussian'
        H_out = 1-exp(-((D.^2-D0^2)./(D.*W)).^2);
    otherwise
       error('Unknown filter type.')
end
end

