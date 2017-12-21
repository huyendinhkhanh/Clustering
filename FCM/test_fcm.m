function [image_out]=test_fcm(IM,epsilon,num_clust,max_iter)
tStart=tic;% timing runing code
%load image
filename=IM;
img_orig=imread(filename);
img=imresize(img_orig,0.1);
img_gray=rgb2gray(img_orig);
img_dou=im2double(img_gray);
img2=imresize(img_dou,0.1);

fname = sprintf('C:\\TEST_150517\\FCM\\%s',filename);
mkdir(fname);
filetext = sprintf('%s\\FCM.txt',fname);
filetext2 = sprintf('%s\\index_result',fname);
fileID = fopen(filetext,'w');

exponent  = 2.0;                         % Exponent for U
% epsilon = 0.005;
% num_clust  = 3;                          % Number of clusters
% exponent  = 2.0;                         % Exponent for U
% max_iter  = 150;                         % Max. iteration
% min_impro = 1e-6;                        % Min. improvement

opts = [exponent; max_iter; epsilon; nan];

Data_normal = mypca(img2,3);

[center, U, obj_fcn] = FCMClust(Data_normal, num_clust, opts);

[~, clust] = max(U);
clust = clust';

% figure
% plot3(Data_normal(:,1),Data_normal(:,2),Data_normal(:,3),'.b','linewidt',2);
% set(gca,'nextplot','add');
% plot3(center(:,1),center(:,2),center(:,3),'xr','linewidt',3);
% h = legend('Data to clusterize','Centroids');
% set(h,'fontsize',16,'fontweight','bold');
% title('FCM');
print(filetext2,'-djpeg');

color = [0 0 0;  255 255 255;  0 0 255;  0 255 0; 236 135 14;
    152	208	185;  255 0 0;
    255 255 0; 255 0 255; 245 168 154; 148	83	5;
    156	153	0; 54 117 23;  0	98	65; 175	215	136
    16	54	103; 81	31	144; 160 149 196; 197 124 172; 215	215	215];

U_2=U';
image_out=img;
row = size(image_out,1);
column = size(image_out,2);
for i=1:row
    for j=1:column
        for k=1:256
            if image_out(i,j)==k-1
                for l=1:num_clust
                    if l>size(U_2,2)
                        break;
                    else
                        if k>size(U_2,1)
                            break;
                        else
                            res=max(U_2(k,:));
                            if U_2(k,l)==res
                                image_out(i,j,:)=color(l,:);
                            end
                        end
                    end
                end
                
            end
        end
    end
end

% figure,imshow(image_out);

% X=Data_normal;
% gscatter(center(:,1), center(:,2), center(:,3));
% axis equal, hold on
% for k=1:2
%     %# indices of points in this group
%     idx = ( center(:,3) == k );
% 
%     %# substract mean
%     Mu = mean( X(idx,:) );
%     X0 = bsxfun(@minus, X(idx,:), Mu);
% 
%     %# eigen decomposition [sorted by eigen values]
%     [V D] = eig( X0'*X0 ./ (sum(idx)-1) );     %#' cov(X0)
%     [D order] = sort(diag(D), 'descend');
%     D = diag(D);
%     V = V(:, order);
% 
%     t = linspace(0,2*pi,100);
%     e = [cos(t) ; sin(t)];        %# unit circle
%     VV = V*sqrt(D);               %# scale eigenvectors
%     e = bsxfun(@plus, VV*e, Mu'); %#' project circle back to orig space
% 
%     %# plot cov and major/minor axes
%     plot(e(1,:), e(2,:), 'Color','k');
%     %#quiver(Mu(1),Mu(2), VV(1,1),VV(2,1), 'Color','k')
%     %#quiver(Mu(1),Mu(2), VV(1,2),VV(2,2), 'Color','k')
% end

cut=1;

num_clust = numel(unique(clust));
center_id = center;

% find best DB index
db = DB(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(db)==0) && (db~=1)
    if (cut ==1)
        max_index(1,1) = cut;
        max_index(1,2) = db;
    else if (db < max_index(1,2))
            max_index(1,1) = cut;
            max_index(1,2) = db;
        end
    end
end

% find best SWC index
swc = SWC(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(swc)==0) && (swc~=1)
    if (cut ==1)
        max_index(2,1) = cut;
        max_index(2,2) = swc;
    else if (swc > max_index(2,2))
            max_index(2,1) = cut;
            max_index(2,2) = swc;
        end
    end
end

% find best IFV index
ifv = IFV(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(ifv)==0) && (ifv~=1)
    if (cut ==1)
        max_index(2,1) = cut;
        max_index(3,2) = ifv;
    else if (ifv > max_index(3,2)|| isnan(ifv))
            max_index(2,1) = cut;
            max_index(3,2) = ifv;
        end
    end
end

% find best PBM index
pbm = PBM(Data_normal, center_id, clust);
if (num_clust~=1) && (isnan(pbm)==0) && (pbm~=1)
    if (cut ==1)
        max_index(2,1) = cut;
        max_index(4,2) = pbm;
    else if (pbm > max_index(4,2))
            max_index(2,1) = cut;
            max_index(4,2) = pbm;
        end
    end
end
cut=cut-0.0005;

cnr =Compute_VM(img2,5,5);

% fprintf('Best DB ECA: %f in Lambda = %f \n',max_index(1,2),max_index(1,1));
% fprintf('Best SWC ECA: %f in Lambda = %f \n',max_index(2,2),max_index(2,1));
% fprintf('Best IFV ECA: %f in Lambda = %f \n',max_index(3,2),max_index(3,1));
% fprintf('Best PBM ECA: %f in Lambda = %f \n',max_index(4,2),max_index(4,1));
% tElapsed=toc(tStart);
% fprintf('time runing: %f\n',tElapsed);

% fprintf(fileID,'DB: %f\n',db);
% fprintf(fileID,'SWC: %f\n',swc);
% fprintf(fileID,'IFV: %f\n',ifv);
% fprintf(fileID,'PBM: %f\n',pbm);
% fprintf(fileID,'VM: %f\n',cnr);

fprintf(fileID,'%f\n',db);
fprintf(fileID,'%f\n',swc);
fprintf(fileID,'%f\n',ifv);
fprintf(fileID,'%f\n',pbm);
fprintf(fileID,'%f\n',cnr);

filetext1 = sprintf('%s\\img_result.jpg',fname);
imwrite(image_out,filetext1);
tElapsed=toc(tStart);
% fprintf(fileID,'time runing: %f',tElapsed);
fprintf(fileID,'%f',tElapsed);

end