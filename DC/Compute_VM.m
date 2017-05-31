function CNR =Compute_VM(IM,sigma1,sigma2)
epsilon=1e-1;
half_size1 = ceil( -norminv( epsilon/2, 0, sigma1 ) );
size1 = 2 * half_size1 + 1 ;
half_size2 = ceil( -norminv( epsilon/2, 0, sigma2 ) );
size2 = 2 * half_size2 + 1 ;
gaussian1 = fspecial( 'gaussian', size1, sigma1 ) ;
gaussian2 = fspecial( 'gaussian', size2, sigma2 ) ;
IM = abs(IM - imfilter( IM, gaussian1, 'replicate' )) ;
noise = IM - imfilter( IM, gaussian1, 'replicate' ) ;
lsd = sqrt(imfilter( noise.^2, gaussian2, 'replicate' ) ) ;
lsd =  lsd./max( lsd( : ) ) .*255 ; % normalize
% figure; imshow(lsd,[])
CNR = sum(lsd(:))/(size(lsd,1)*size(lsd,2));